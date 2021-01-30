
include .env

src = $(shell find src/ -iname *.ts)
e2e_tests = $(shell find test/ -iname *.ts)

all: status lint format test e2e

echo:
	@echo "src"
	@echo $(src)
	@echo "tests"
	@echo $(tests)

# Check the current state of the repository. 
# Handy for doing things like ```$> git rebase -x {start-commit}``` so you can see progress as each commit is re-built
status: | tmp/
	git status
	@touch --date "$(shell $(DOCKER) image inspect --format "{{.Metadata.LastTagTime.Format \"Mon, 2 Jan 2006 15:04:05 -0700\"}}" $(MARKDOWN_IMAGE))" tmp/image

# Re-build the service image
build: tmp/image

# Push the service image to the container registry
push:
	$(DOCKER) push $(MARKDOWN_IMAGE)

# Pull the service image from the container registry
pull:
	$(DOCKER) pull $(MARKDOWN_IMAGE)

install: node_modules/


lint: tmp/lint

format: tmp/format

test: tmp/test

e2e: tmp/e2e

.PHONY: all status build push pull install echo lint format test e2e

.env:
	cp defaults.env $@

node_modules/: package.json
	$(NPM) install

tmp/:
	mkdir -p $@

tmp/lint: $(src) $(e2e_tests) .eslintrc.js node_modules/ | tmp/
	@echo "Found newer lint dependencies:" $?
	$(NPX) eslint "{src,test}/**/*.ts" --fix
	@touch $@

tmp/format: $(src) $(e2e_tests) .prettierrc node_modules/ | tmp/
	@echo "Found newer format dependencies:" $?
	$(NPX) prettier --write "src/**/*.ts" "test/**/*.ts"
	@touch $@

tmp/test: $(src) node_modules/ | tmp/
	@echo "Found newer test dependencies:" $?
	$(NPX) jest
	@touch $@

dist/: $(src) tsconfig.json tsconfig.build.json nest-cli.json node_modules/
	@rm -fr dist/
	$(NEST) build

tmp/image: dist/ Dockerfile | tmp/
	@echo "Found newer build dependencies:" $?
	$(DOCKER) build -t $(MARKDOWN_IMAGE) .
	@touch $@

tmp/e2e: tmp/image $(e2e_tests) test/jest-e2e.json node_modules/ | tmp/
	@echo "Found newer e2e dependencies:" $?
	$(NPX) jest --config ./test/jest-e2e.json
	@touch $@
