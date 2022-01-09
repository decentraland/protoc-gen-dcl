PROTOBUF_VERSION = 3.19.1
PROTOC ?= protoc
UNAME := $(shell uname)
PROTO_FILES := $(wildcard src/*.proto)
export PATH := node_modules/.bin:/usr/local/include/:protoc3/bin:$(PATH)

ifneq ($(CI), true)
LOCAL_ARG = --local --verbose --diagnostics
endif

ifeq ($(UNAME),Darwin)
PROTOBUF_ZIP = protoc-$(PROTOBUF_VERSION)-osx-x86_64.zip
else
PROTOBUF_ZIP = protoc-$(PROTOBUF_VERSION)-linux-x86_64.zip
endif

install_compiler:
	@# remove local folder
	rm -rf protoc3 || true

	@# Make sure you grab the latest version
	curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v$(PROTOBUF_VERSION)/$(PROTOBUF_ZIP)

	@# Unzip
	unzip $(PROTOBUF_ZIP) -d protoc3
	@# delete the files
	rm $(PROTOBUF_ZIP)

	@# move protoc to /usr/local/bin/
	chmod +x protoc3/bin/protoc

install: install_compiler
	npm install
	npm i -S google-protobuf@$(PROTOBUF_VERSION)
	npm i -S @types/google-protobuf@latest

test: build
	${PROTOC} \
		"--plugin=protoc-gen-dcl=./dist/bin.js" \
		"-I=$(PWD)/test/codegen" \
		"--js_out=import_style=commonjs,binary:$(PWD)/test/codegen" \
		"--dcl_out=$(PWD)/test/codegen" \
		"$(PWD)/test/codegen/s1.proto"
	node_modules/.bin/jest --detectOpenHandles --colors --runInBand $(TESTARGS) --coverage

test-watch:
	node_modules/.bin/jest --detectOpenHandles --colors --runInBand --watch $(TESTARGS) --coverage

build:
	@rm -rf dist || true
	@mkdir -p dist
	./node_modules/.bin/tsc -p tsconfig.json
	chmod +x ./dist/bin.js

.PHONY: build test codegen
