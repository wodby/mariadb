-include env_make

# The official image is published some time after a MariaDB release, so this
# version is tracked separately from the Alpine images built from source.
MARIADB_VER ?= 11.8.9
MARIADB_VER_MINOR = $(shell echo "${MARIADB_VER}" | grep -oE '^[0-9]+\.[0-9]+')
MARIADB_VER_MAJOR = $(shell echo "${MARIADB_VER}" | grep -oE '^[0-9]+')

# The directory whose action scripts the Alpine image of this version uses.
SCRIPTS_DIR ?= $(MARIADB_VER_MAJOR)

# wodby/alpine supplies the helper scripts; its pin is the one in ../base-images.mk.
BASE_IMAGE_REVISION ?= $(BASE_IMAGE_STABILITY_TAG)
ALPINE_VER ?= 3.22
ifeq ($(BASE_IMAGE_REVISION),)
    HELPERS_TAG := $(ALPINE_VER)
else
    HELPERS_TAG := $(ALPINE_VER)-$(BASE_IMAGE_REVISION)
endif
HELPERS_DIGEST = $(shell sed -n 's/^BASE_IMAGE_DIGEST_$(HELPERS_TAG) := //p' ../base-images.mk)
HELPERS_IMAGE = wodby/alpine:$(HELPERS_TAG)@$(or $(HELPERS_DIGEST),$(error No base image digest for wodby/alpine:$(HELPERS_TAG); update base-images.mk))

PLATFORM ?= linux/arm64

TAG_SUFFIX = -ubuntu
TAG ?= $(MARIADB_VER_MINOR)$(TAG_SUFFIX)

REPO = wodby/mariadb
NAME = mariadb-$(MARIADB_VER_MINOR)$(TAG_SUFFIX)

ifneq ($(ARCH),)
	override TAG := $(TAG)-$(ARCH)
endif

.PHONY: build buildx-build buildx-push test push shell run start stop logs clean release

# Resolve the same pinned official image for every local and CI build target.
include base-images.mk
BASE_IMAGE_TAG = $(MARIADB_VER)

BUILD_ARGS = --build-arg BASE_IMAGE="$(BASE_IMAGE)" \
	    --build-arg HELPERS_IMAGE="$(HELPERS_IMAGE)" \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg SCRIPTS_DIR=$(SCRIPTS_DIR)

default: build

# The build context is the repository root: the action scripts are shared with
# the Alpine images.
build:
	docker build $(BUILD_ARGS) -t $(REPO):$(TAG) -f Dockerfile ../

buildx-build:
	docker buildx build $(BUILD_ARGS) --platform $(PLATFORM) -t $(REPO):$(TAG) -f Dockerfile ../

buildx-push:
	docker buildx build $(BUILD_ARGS) --push --platform $(PLATFORM) -t $(REPO):$(TAG) -f Dockerfile ../

# CI combines the exact architecture images this workflow run pushed; see
# wodby/images arch-image-pins.
arch-image = $(if $(ARCH_IMAGE_PINS),$(or $(shell cat '$(ARCH_IMAGE_PINS)/$(subst :,_,$(subst /,_,$(1)))' 2>/dev/null),$(error No digest of $(1) was pushed by this workflow run)),$(1))

buildx-imagetools-create:
	docker buildx imagetools create -t $(REPO):$(TAG) \
				  $(call arch-image,$(REPO):$(MARIADB_VER_MINOR)$(TAG_SUFFIX)-amd64) \
				  $(call arch-image,$(REPO):$(MARIADB_VER_MINOR)$(TAG_SUFFIX)-arm64)
.PHONY: buildx-imagetools-create

test:
	cd ./tests && IMAGE=$(REPO):$(TAG) ./run.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -e DEBUG=1 -e MARIADB_RANDOM_ROOT_PASSWORD=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) -e MARIADB_RANDOM_ROOT_PASSWORD=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

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
