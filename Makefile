
include .env

all: status build

status:
	git status

build:
	$(DOCKER) build -t $(MARKDOWN_IMAGE) .

push:
	$(DOCKER) push $(MARKDOWN_IMAGE)

pull:
	$(DOCKER) pull $(MARKDOWN_IMAGE)

.PHONY: all status

.env:
	cp defaults.env $@
