-include env_make

MARIADB_VER ?= 11.4.8
MARIADB_VER_MINOR = $(shell echo "${MARIADB_VER}" | grep -oE '^[0-9]+\.[0-9]+')

GALERA_VER ?=
WSREP_VER ?= $(shell echo "${GALERA_VER}" | grep -oE '^[0-9]+')

ALPINE_VER ?= 3.21

NPROC =

PLATFORM ?= linux/arm64

ifeq ($(BASE_IMAGE_STABILITY_TAG),)
    BASE_IMAGE_TAG := $(ALPINE_VER)
else
    BASE_IMAGE_TAG := $(ALPINE_VER)-$(BASE_IMAGE_STABILITY_TAG)
endif

TAG ?= $(MARIADB_VER_MINOR)

REPO = wodby/mariadb
NAME = mariadb-$(MARIADB_VER_MINOR)

ifneq ($(ARCH),)
	override TAG := $(TAG)-$(ARCH)
endif

.PHONY: build buildx-build buildx-push test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg MARIADB_VER_MINOR=$(MARIADB_VER_MINOR) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg WSREP_VER=$(WSREP_VER) \
	    --build-arg NPROC=$(NPROC) ./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg MARIADB_VER_MINOR=$(MARIADB_VER_MINOR) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg WSREP_VER=$(WSREP_VER) \
	    --build-arg NPROC=$(NPROC) ./

buildx-push:
	docker buildx build --push --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg MARIADB_VER=$(MARIADB_VER) \
	    --build-arg MARIADB_VER_MINOR=$(MARIADB_VER_MINOR) \
	    --build-arg GALERA_VER=$(GALERA_VER) \
	    --build-arg WSREP_VER=$(WSREP_VER) \
	    --build-arg NPROC=$(NPROC) ./

buildx-imagetools-create:
	docker buildx imagetools create -t $(REPO):$(TAG) \
				  $(REPO):$(MARIADB_VER_MINOR)-amd64 \
				  $(REPO):$(MARIADB_VER_MINOR)-arm64
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
