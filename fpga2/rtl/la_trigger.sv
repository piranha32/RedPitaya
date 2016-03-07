////////////////////////////////////////////////////////////////////////////////
// Module: LA trigger detection
// Authors: Matej Oblak, Iztok Jeras
// (c) Red Pitaya  http://www.redpitaya.com
////////////////////////////////////////////////////////////////////////////////

module la_trigger #(
  int unsigned DN = 1,
  type DT = logic [8-1:0]  // str.dat type
)(
  // control
  input  logic ctl_rst,  // synchronous reset
  // configuration
  input  DT    cfg_cmp_msk,  // comparator mask
  input  DT    cfg_cmp_val,  // comparator value
  input  DT    cfg_edg_pos,  // edge positive
  input  DT    cfg_edg_neg,  // edge negative
  // output triggers
  output logic sts_trg,  // TODO: should have DN width
  // stream monitor
  axi4_stream_if.m str
);

DT    str_old;

logic sts_cmp;
logic sts_edg;

assign sts_cmp = (str.TDATA & cfg_cmp_msk) == (cfg_cmp_val & cfg_cmp_msk);
assign sts_edg = |(cfg_edg_pos & (~str_old &  str.TDATA))
               | |(cfg_edg_neg & ( str_old & ~str.TDATA));

always @(posedge str.ACLK)
if (str.transf)  str_old <= str.TDATA;

always @(posedge str.ACLK)
if (~str.ARESETn) begin
  sts_trg <= '0;
end else begin
  if (ctl_rst) begin
    sts_trg <= '0;
  end if (str.transf) begin
    sts_trg <= sts_cmp & sts_edg;
  end
end

endmodule: la_trigger
