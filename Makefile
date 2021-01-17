
include .env

all: status build

# Check the current state of the repository. 
# Handy for doing things like ```$> git rebase -x {start-commit}``` so you can see progress as each commit is re-built
status:
	git status

# Re-build the service image
build:
	$(DOCKER) build -t $(MARKDOWN_IMAGE) .

# Push the service image to the container registry
push:
	$(DOCKER) push $(MARKDOWN_IMAGE)

# Pull the service image from the container registry
pull:
	$(DOCKER) pull $(MARKDOWN_IMAGE)

.PHONY: all status push pull

.env:
	cp defaults.env $@
