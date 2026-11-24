#!/usr/bin/env bash

# Version aliases identify published releases; only primary tags publish images.
if [[ "${GITHUB_REF:-}" =~ ^refs/tags/.+-r[0-9]+$ ]]; then
    exit 0
fi

set -exo pipefail

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then      
  minor_ver="${MARIADB_VER%.*}"
  major_ver="${minor_ver%.*}"

  # A variant keeps its suffix in every tag: 11.8-ubuntu, 11-ubuntu, 11.8-ubuntu-r1.
  minor_tag="${minor_ver}${TAG_SUFFIX}"
  major_tag="${major_ver}${TAG_SUFFIX}"

  tags=("${minor_tag}")

  if [[ -n "${LATEST_MAJOR}" ]]; then
    tags+=("${major_tag}")
  fi  

  if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
    image_revision=("${GITHUB_REF##*/}")
    tags=("${minor_tag}-${image_revision}")
    if [[ -n "${LATEST_MAJOR}" ]]; then
      tags+=("${major_tag}-${image_revision}")
    fi
  else          
    if [[ -n "${LATEST}" ]]; then
      tags+=("latest")
    fi
  fi

  for tag in "${tags[@]}"; do
    make buildx-imagetools-create TAG=${tag}
  done
fi