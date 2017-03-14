#!/usr/bin/env bash

set -e

if [[ ! -z "${DEBUG}" ]]; then
  set -x
fi

started=0
root_password=$1
host=$2
max_try=$3
wait_seconds=$4

for i in $(seq 1 "${max_try}"); do
    if mysql -uroot -p"${root_password}" -h"${host}" -e 'SELECT 1' &> /dev/null; then
        started=1
        break
    fi
    echo 'MariaDB is starting...'
    sleep "${wait_seconds}"
done

if [[ "${started}" -eq '0' ]]; then
    echo >&2 'Error. MariaDB is unreachable.'
    exit 1
fi

echo 'MariaDB has started!'
