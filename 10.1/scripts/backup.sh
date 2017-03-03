#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

root_password="${1}"
host="${2}"
db="${3}"
filepath="${4}"
filename="dump.sql"
tmp_dir="/tmp/$RANDOM"

mkdir -p ${tmp_dir}
cd ${tmp_dir}
mysqldump --allow-keywords -h${host} -uroot -p${root_password} ${db} -r ${filename}
gzip ${filename}
mv "${filename}.gz" ${filepath}
