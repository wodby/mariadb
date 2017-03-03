#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

root_password="${1}"
host="${2}"
db="${3}"
source="${4}"
tmp_dir="/tmp/import"

mkdir -p ${tmp_dir}
cd ${tmp_dir}

if [[ ${source} =~ ^https?:// ]]; then
    wget -q ${source}
else
    mv ${source} .
fi

archive_file=$(find -type f)

if [[ ${archive_file} =~ \.zip$ ]]; then
    unzip ${archive_file}
elif [[ ${archive_file} =~ \.gz$ ]]; then
    gunzip ${archive_file}
else
    echo >&2 'Unsupported file format. Expecting single SQL file compressed as .gz .zip'
    exit 1
fi

if [ "$(find -type f -name "*.sql" | wc -l)" != "1" ]; then
    echo >&2 "Expecting single SQL file, multiple found: $(find -type f -name '*.sql')"
    exit 1
fi

sql_file=$(find -type f -name "*.sql")

mysql -h${host} -uroot -p${root_password} -e "DROP DATABASE IF EXISTS ${db};"
mysql -h${host} -uroot -p${root_password} -e "CREATE DATABASE ${db};"
mysql -h${host} -uroot -p${root_password} ${db} < ${sql_file}
