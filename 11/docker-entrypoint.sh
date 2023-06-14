#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo init_volumes

minor_ver=$(echo "${MARIADB_VER}" | grep -oE '^[0-9]+\.[0-9]+')
gotpl "/etc/gotpl/${minor_ver}/my.cnf.tmpl" > "/etc/mysql/my.cnf"

init_mariadb "${@}"

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec "${@}"
fi