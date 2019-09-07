
.NOTPARALLEL:

ifeq ($(VERSION),)
VERSION:=$(patsubst v%,%,$(shell git describe --tags `git rev-list --tags --max-count=1`))
endif
ifeq ($(VERSION),)
$(error Cannot determine version. Aborting.)
endif
 
all: edge vision

edge:
	$(MAKE) -C edge all

vision:
	$(MAKE) -C visionlibs all
	$(MAKE) -C vision all
