#!/usr/bin/env bash

set -e

if [[ ! -z "${DEBUG}" ]]; then
    set -x
fi

query() {
    mysql -h"${host}" -uroot -p"${root_password}" -e "${@}"
}

restore_privileges() {
    query "GRANT ALL ON \`${db}\`.* TO '${user}'@'%';"
}

user=$1
root_password=$2
host=$3
db=$4
source=$5
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
    unzip "${archive_file}" -x "__MACOSX/*"
    rm -f "${archive_file}"
elif [[ "${archive_file}" =~ \.tgz$ ]] || [[ "${archive_file}" =~ \.tar.gz$ ]]; then
    tar --exclude="./__MACOSX" -zxf "${archive_file}"
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

query "REVOKE ALL PRIVILEGES ON \`${db}\`.* FROM '${user}'@'%';"
query "DROP DATABASE IF EXISTS ${db};"
query "CREATE DATABASE ${db};"

trap 'restore_privileges' EXIT
mysql -h"${host}" -uroot -p"${root_password}" "${db}" < "${dump_file}"

restore_privileges
query 'FLUSH PRIVILEGES;'

rm -rf "${tmp_dir}"