DOCKER_IMAGE ?= lephare/php
PHP_VERSIONS ?= $(patsubst %/,%,$(sort $(dir $(wildcard */Dockerfile))))
SUPPORTED_VERSIONS ?= 7.1 7.2 7.3
PLATFORMS ?= linux/amd64,linux/arm64

.PHONY: $(PHP_VERSIONS) all

supported: $(SUPPORTED_VERSIONS)
all: $(PHP_VERSIONS)

setup:
	-docker buildx rm php-builder
	docker buildx create --name php-builder --platform=$(PLATFORMS)

$(PHP_VERSIONS): setup
	docker buildx build  --pull --platform=$(PLATFORMS) -t $(DOCKER_IMAGE):$@ $@
