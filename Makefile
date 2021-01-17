
include .env

all: status

status:
	git status

.PHONY: all status

.env:
	cp defaults.env $@
