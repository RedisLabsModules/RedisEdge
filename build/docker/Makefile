
.NOTPARALLEL:

ifeq ($(VERSION),)
VERSION:=$(patsubst v%,%,$(shell git describe --tags `git rev-list --tags --max-count=1`))
endif
ifeq ($(VERSION),)
$(error Cannot determine version. Aborting.)
endif
 
all: edge vision

edge:
	@echo Building RedisEdge v$(VERSION) ...
	$(MAKE) -C edge

vision:
	@echo Building RedisEdgeVision v$(VERSION) ...
	$(MAKE) -C vision

pylibs:
	@echo Building RedisEdge Python Libraries v$(VERSION) ...
	$(MAKE) -C pylibs

build:
	$(MAKE) -C edge build
	$(MAKE) -C vision build

publish:
	$(MAKE) -C edge publish
	$(MAKE) -C vision publish

.PHONY: all edge vision pylibs build publish
