-include env_make

MARIADB_VER ?= 10.6.5
MARIADB_VER_MINOR = $(shell echo "${MARIADB_VER}" | grep -oE '^[0-9]+\.[0-9]+')

GALERA_VER ?=
WSREP_VER ?= $(shell echo "${GALERA_VER}" | grep -oE '^[0-9]+')

ALPINE_VER ?= 3.12

NPROC =

PLATFORM ?= linux/amd64

ifeq ($(BASE_IMAGE_STABILITY_TAG),)
    BASE_IMAGE_TAG := $(ALPINE_VER)
else
    BASE_IMAGE_TAG := $(ALPINE_VER)-$(BASE_IMAGE_STABILITY_TAG)
endif

# Remove minor version from tag
TAG ?= $(MARIADB_VER_MINOR)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

REPO = wodby/mariadb
NAME = mariadb-$(MARIADB_VER_MINOR)

.PHONY: build buildx-build buildx-push buildx-build-amd64 test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg WSREP_VER=$(WSREP_VER) \
	    --build-arg NPROC=$(NPROC) ./

# --load doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker buildx build --platform linux/amd64 -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg WSREP_VER=$(WSREP_VER) \
	    --build-arg NPROC=$(NPROC) \
		--load \
	    ./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg WSREP_VER=$(WSREP_VER) \
	    --build-arg NPROC=$(NPROC) ./

buildx-push:
	docker buildx build --push --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg WSREP_VER=$(WSREP_VER) \
	    --build-arg NPROC=$(NPROC) ./

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
