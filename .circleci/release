#!/usr/bin/env bash

set -e

if [[ -z "${CIRCLE_PULL_REQUEST}" && ("${CIRCLE_BRANCH}" == "master"  || -n "${CIRCLE_TAG}") ]]; then
  docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

  if [[ -n "${CIRCLE_TAG}" ]]; then
    export STABILITY_TAG="${CIRCLE_TAG}"
  fi

  cd "${MARIADB_VER:0:2}"
  make release

  if [[ -n "${EXTRA_TAG}" ]]; then
    make release TAG="${EXTRA_TAG}"
  fi

  if [[ "${TAG}" == "${LATEST_TAG}" ]]; then
    make release TAG="latest"
  fi
fi