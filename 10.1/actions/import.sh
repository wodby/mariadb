#!/usr/bin/env bash

set -e

if [[ ! -z "${DEBUG}" ]]; then
  set -x
fi

root_password=$1
host=$2
db=$3
source=$4
tmp_dir="/tmp/import"

[ -d "${tmp_dir}" ] && rm -rf "${tmp_dir}"
mkdir -p "${tmp_dir}"
cd "${tmp_dir}"

if [[ "${source}" =~ ^https?:// ]]; then
    wget -q "${source}"
else
    mv "${source}" .
fi

archive_file=$(find -type f)

if [[ "${archive_file}" =~ \.zip$ ]]; then
    unzip "${archive_file}"
    rm -f "${archive_file}"
elif [[ "${archive_file}" =~ \.tgz$ ]] || [[ "${archive_file}" =~ \.tar.gz$ ]]; then
    tar -zxf "${archive_file}"
    rm -f "${archive_file}"
elif [[ "${archive_file}" =~ \.gz$ ]]; then
    gunzip "${archive_file}"
else
    echo >&2 'Unsupported file format. Expecting single SQL file compressed as .gz .zip .tar.gz .tgz'
    exit 1
fi

if [ "$(find -type f | wc -l)" != "1" ]; then
    echo >&2 "Expecting single file, none or multiple found: $(find -type f)"
    exit 1
fi

dump_file=$(find -type f)

mysql -h"${host}" -uroot -p"${root_password}" -e "DROP DATABASE IF EXISTS ${db};"
mysql -h"${host}" -uroot -p"${root_password}" -e "CREATE DATABASE ${db};"
mysql -h"${host}" -uroot -p"${root_password}" "${db}" < "${dump_file}"

rm -rf "${tmp_dir}"