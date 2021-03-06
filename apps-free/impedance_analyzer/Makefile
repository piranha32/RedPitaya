#
# Authors: Aleš Bardorfer, Luka Golinar
#
# Red Pitaya specific application Makefile.
#

APP=$(notdir $(CURDIR:%/=%))

# Versioning system
BUILD_NUMBER ?= 0
REVISION ?= devbuild
VER:=$(shell cat info/info.json | grep version | sed -e 's/.*:\ *\"//' | sed -e 's/-.*//')

INSTALL_DIR ?= .

CONTROLLERHF = controllerhf.so
ZIP = ../../$(APP)-$(VER)-$(BUILD_NUMBER)-$(REVISION).zip
LCR          = $(INSTALL_DIR)/bin/lcr

CFLAGS += -DVERSION=$(VER)-$(BUILD_NUMBER) -DREVISION=$(REVISION)
export CFLAGS

all: $(CONTROLLERHF)

$(CONTROLLERHF):
	$(MAKE) -C src

$(LCR):
	$(MAKE) -C ../../ lcr

$(ZIP): $(CONTROLLERHF)
	-$(RM) target -rf
	mkdir -p target/$(APP)
	cp -r $(CONTROLLERHF) $(LCR) fpga.conf info index.html style.css images target/$(APP)
	sed -i target/$(APP)/info/info.json -e 's/REVISION/$(REVISION)/'
	sed -i target/$(APP)/info/info.json -e 's/BUILD_NUMBER/$(BUILD_NUMBER)/'
	cd target; zip -r ../$(ZIP) *
	$(RM) target -rf

install: $(ZIP)
	unzip $(ZIP) -d $(INSTALL_DIR)/www/apps

clean:
	$(MAKE) -C src clean
	-$(RM) target -rf
	-$(RM) *.so
