# check=skip=InvalidDefaultArgInFrom

# Variant built on the official MariaDB image: MariaDB's own server and Galera
# packages on Ubuntu, with this repository's orchestration actions on top. The
# build context is the repository root, so the action scripts are the same
# files the Alpine images use.
#
# The server is configured as in the official image, with files in
# /etc/mysql/conf.d. Nothing is generated when the container starts: tools such
# as Kubernetes operators also run the image with their own command, for example
# "mariadbd --wsrep-recover", and that run must see the same configuration.

# The Makefile supplies the digest-pinned BASE_IMAGE and HELPERS_IMAGE arguments.
ARG BASE_IMAGE
ARG HELPERS_IMAGE

# wodby/alpine holds the helper scripts the actions call. Nothing else is taken from it.
FROM ${HELPERS_IMAGE} AS helpers

FROM ${BASE_IMAGE}

ARG MARIADB_VER
ARG SCRIPTS_DIR

ENV MARIADB_VER="${MARIADB_VER}" \
    BACKUPS_DIR="/mnt/backups"

RUN set -ex; \
    \
    apt-get update; \
    # Security updates published since the pinned base image was built.
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
        7zip \
        ca-certificates \
        # garbd, from the MariaDB repository the base image is built from, so
        # it matches the Galera library that image ships.
        galera-arbitrator-4 \
        make \
        wget; \
    rm -rf /var/lib/apt/lists/*; \
    \
    mkdir -p "${BACKUPS_DIR}"; \
    chown mysql:mysql "${BACKUPS_DIR}"

COPY --from=helpers /usr/local/bin/get_archive /usr/local/bin/wait_for /usr/local/bin/
COPY ${SCRIPTS_DIR}/bin/actions.mk ${SCRIPTS_DIR}/bin/backup ${SCRIPTS_DIR}/bin/backup_stream ${SCRIPTS_DIR}/bin/import /usr/local/bin/
COPY ubuntu/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mariadbd"]
