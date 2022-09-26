SHELL := /bin/bash
VERSION := 1.0
DOCKERTAG_NAME := protoc-tool

dockerbuild:
	docker build --rm --label version=${VERSION} -t ${DOCKERTAG_NAME}:latest -t ${DOCKERTAG_NAME}:${VERSION} .
