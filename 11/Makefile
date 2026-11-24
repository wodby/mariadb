-include env_make

# Accept legacy build arguments during the image revision transition.
BASE_IMAGE_REVISION ?= $(BASE_IMAGE_STABILITY_TAG)

MARIADB_VER ?= 11.8.10
MARIADB_VER_MINOR = $(shell echo "${MARIADB_VER}" | grep -oE '^[0-9]+\.[0-9]+')

GALERA_VER ?= 26.4.29
# SHA-256 of the release_$(GALERA_VER) source archive; update it with GALERA_VER.
GALERA_SHA256 ?= 3b6c340949cee9d8e7fb995c70725c6c7552446bf4ea8218e6299de774b99dcc
# The wsrep-API commit that release pins as its wsrep/src submodule, and the
# SHA-256 of its source archive. Galera is built with it, not with the copy
# in the MariaDB source, which can be older than the release needs.
WSREP_API_COMMIT ?= e8313df29e9329521dced03a4cc558d0cf7d8032
WSREP_API_SHA256 ?= d6c004890133f29536abffbff506620c9196003e5144033f6cf22e379aa11606

ALPINE_VER ?= 3.22

NPROC =

PLATFORM ?= linux/arm64

ifeq ($(BASE_IMAGE_REVISION),)
    BASE_IMAGE_TAG := $(ALPINE_VER)
else
    BASE_IMAGE_TAG := $(ALPINE_VER)-$(BASE_IMAGE_REVISION)
endif

TAG ?= $(MARIADB_VER_MINOR)

REPO = wodby/mariadb
NAME = mariadb-$(MARIADB_VER_MINOR)

ifneq ($(ARCH),)
	override TAG := $(TAG)-$(ARCH)
endif

.PHONY: build buildx-build buildx-push test push shell run start stop logs clean release

# Resolve the same pinned base image for every local and CI build target.
include ../base-images.mk

default: build

build:
	docker build --build-arg BASE_IMAGE="$(BASE_IMAGE)" -t $(REPO):$(TAG) \
	    \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg MARIADB_VER_MINOR=$(MARIADB_VER_MINOR) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg GALERA_SHA256=$(GALERA_SHA256) \
	    --build-arg WSREP_API_COMMIT=$(WSREP_API_COMMIT) \
	    --build-arg WSREP_API_SHA256=$(WSREP_API_SHA256) \
	    --build-arg NPROC=$(NPROC) ./

buildx-build:
	docker buildx build --build-arg BASE_IMAGE="$(BASE_IMAGE)" --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg MARIADB_VER_MINOR=$(MARIADB_VER_MINOR) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg GALERA_SHA256=$(GALERA_SHA256) \
	    --build-arg WSREP_API_COMMIT=$(WSREP_API_COMMIT) \
	    --build-arg WSREP_API_SHA256=$(WSREP_API_SHA256) \
	    --build-arg NPROC=$(NPROC) ./

buildx-push:
	docker buildx build --build-arg BASE_IMAGE="$(BASE_IMAGE)" --push --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg MARIADB_VER_MINOR=$(MARIADB_VER_MINOR) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg GALERA_SHA256=$(GALERA_SHA256) \
	    --build-arg WSREP_API_COMMIT=$(WSREP_API_COMMIT) \
	    --build-arg WSREP_API_SHA256=$(WSREP_API_SHA256) \
	    --build-arg NPROC=$(NPROC) ./

# CI combines the exact architecture images this workflow run pushed; see
# wodby/images arch-image-pins. Per-architecture tags are shared by every run,
# so an overlapping run may already have replaced one of them.
arch-image = $(if $(ARCH_IMAGE_PINS),$(or $(shell cat '$(ARCH_IMAGE_PINS)/$(subst :,_,$(subst /,_,$(1)))' 2>/dev/null),$(error No digest of $(1) was pushed by this workflow run)),$(1))

buildx-imagetools-create:
	docker buildx imagetools create -t $(REPO):$(TAG) \
				  $(call arch-image,$(REPO):$(MARIADB_VER_MINOR)-amd64) \
				  $(call arch-image,$(REPO):$(MARIADB_VER_MINOR)-arm64)
.PHONY: buildx-imagetools-create 

test:
	cd ./tests && IMAGE=$(REPO):$(TAG) ./run.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -e DEBUG=1 -e MYSQL_RANDOM_ROOT_PASSWORD=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) -e MYSQL_RANDOM_ROOT_PASSWORD=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push

# Keep CI scans aligned with the version, variant and architecture built by make.
.PHONY: image-ref
image-ref:
	@printf '%s\n' '$(REPO):$(TAG)'
