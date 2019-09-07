
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
	$(MAKE) -C edge all

vision:
	@echo Building RedisEdgeVision v$(VERSION) ...
	$(MAKE) -C visionlibs all
	$(MAKE) -C vision all
