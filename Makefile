
.NOTPARALLEL:

MAKEFLAGS += --no-builtin-rules  --no-print-directory

define HELP
RedisEdge build operations

make edge     # build RedisEdge (AI, Gears, TimeSereis)
  JETSON=1      # build for 
make vision   # build RedisEdge with ML Python libraries
make pylibs   # Build CPython with ML Python libraries

make build     # build RedisEdge and RedisEdgeVision
make publish   # Push Docker images for RedisEdge and RedisEdgeVision

endef

#----------------------------------------------------------------------------------------------

include versions

ifeq ($(VERSION),)
VERSION:=$(patsubst v%,%,$(shell git describe --tags `git rev-list --tags --max-count=1`))
endif
ifeq ($(VERSION),)
$(error Cannot determine version. Aborting.)
endif
 
all: build

edge:
	@echo Building RedisEdge v$(VERSION) ...
	@$(MAKE) -C edge

vision:
	@echo Building RedisEdgeVision v$(VERSION) ...
	@$(MAKE) -C vision

pylibs:
	@echo Building RedisEdge Python Libraries v$(VERSION) ...
	@$(MAKE) -C pylibs

build:
	@$(MAKE) -C edge build
	@$(MAKE) -C pylibs build
	@$(MAKE) -C vision build

publish:
	@$(MAKE) -C edge publish PUSH_GENERAL=1
	@$(MAKE) -C pylibs publish PUSH_GENERAL=1
	@$(MAKE) -C vision publish PUSH_GENERAL=1

.PHONY: all edge vision pylibs build publish help

#----------------------------------------------------------------------------------------------

ifneq ($(HELP),) 
ifneq ($(filter help,$(MAKECMDGOALS)),)
HELPFILE:=$(shell mktemp /tmp/make.help.XXXX)
endif
endif

help:
	$(file >$(HELPFILE),$(HELP))
	@echo
	@cat $(HELPFILE)
	@echo
	@-rm -f $(HELPFILE)

