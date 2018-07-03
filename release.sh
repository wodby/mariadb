#!/usr/bin/env bash

set -e

if [[ -z "${CIRCLE_PULL_REQUEST}" && ("${CIRCLE_BRANCH}" == "master"  || -n "${CIRCLE_TAG}") ]]; then
    if [[ -n "${CIRCLE_TAG}" ]]; then
        export STABILITY_TAG="${CIRCLE_TAG}"
    fi

    docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

    IFS=',' read -ra tags <<< "${TAGS}"

    for tag in "${tags[@]}"; do
        make release TAG="${tag}";
    done
fi
