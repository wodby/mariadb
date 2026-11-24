#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

# Orchestration actions, as in the Alpine images: "make <action> [params]".
if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
fi

# Everything else is the official image's entrypoint, unchanged.
exec docker-entrypoint.sh "${@}"
