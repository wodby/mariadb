#!/usr/bin/env bash

set -e

if [[ ! -z "${DEBUG}" ]]; then
  set -x
fi

root_password=$1
host=$2
db=$3
filepath=$4
ignore_tables=$5
filename="dump.sql"
tmp_dir="/tmp/$RANDOM"
ignore=()

IFS=';' read -ra ADDR <<< "${ignore_tables}"
for table in "${ADDR[@]}"; do
    ignore+=("--ignore-table=${db}.${table}")
done

mkdir -p "${tmp_dir}"
cd "${tmp_dir}"
mysqldump --no-data --allow-keywords -h"${host}" -uroot -p"${root_password}" "${db}" > "${filename}"
mysqldump --no-create-info "${ignore[@]}" --allow-keywords -h"${host}" -uroot -p"${root_password}" "${db}" >> "${filename}"
gzip "${filename}"
mv "${filename}.gz" "${filepath}"
stat -c "RESULT=%s" "${filepath}"