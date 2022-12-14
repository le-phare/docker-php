DOCKER_IMAGE ?= lephare/php
PHP_VERSIONS ?= $(patsubst %/,%,$(sort $(dir $(wildcard */Dockerfile))))
SUPPORTED_VERSIONS ?= 7.4 8.0 8.1

.PHONY: $(PHP_VERSIONS) all

supported: $(SUPPORTED_VERSIONS)
all: $(PHP_VERSIONS)

$(PHP_VERSIONS):
	docker buildx build -t $(DOCKER_IMAGE):$@ $@
