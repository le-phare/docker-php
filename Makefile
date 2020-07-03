DOCKER_IMAGE ?= lephare/php
PHP_VERSIONS ?= $(patsubst %/,%,$(sort $(dir $(wildcard */Dockerfile))))

.PHONY: $(PHP_VERSIONS) all
	
all: $(PHP_VERSIONS)
	
$(PHP_VERSIONS): 
	docker build -t $(DOCKER_IMAGE):$@ $@
