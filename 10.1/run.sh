#!/bin/bash
set -eo pipefail

image="$1"

export MYSQL_ROOT_PASSWORD='this is an example test password'
export MYSQL_USER='0123456789012345'
export MYSQL_PASSWORD='my cool mysql password'
export MYSQL_DATABASE='my cool mysql database'

cname="mysql-container-$RANDOM-$RANDOM"
cid="$(
	docker run -d \
		-e MYSQL_ROOT_PASSWORD \
		-e MYSQL_USER \
		-e MYSQL_PASSWORD \
		-e MYSQL_DATABASE \
		--name "$cname" \
		"$image"
)"
trap "docker rm -vf $cid > /dev/null" EXIT

waitForMariaDB() {
    done=''

    for i in {30..0}; do
        if $(echo 'SELECT 1' | query &> /dev/null); then
            done=1
            break
        fi
        echo 'MariaDB start process in progress...'
        sleep 5
    done

    if [[ ! "${done}" ]]; then
        echo "Failed to start MariaDB" >&2
        exit 1
    fi
}

query() {
	docker run --rm -i \
		--link "$cname":mysql \
		--entrypoint mysql \
		-e MYSQL_PWD="$MYSQL_PASSWORD" \
		"$image" \
		-hmysql \
		-u"$MYSQL_USER" \
		--silent \
		"$@" \
		"$MYSQL_DATABASE"
}

waitForMariaDB

echo 'CREATE TABLE test (a INT, b INT, c VARCHAR(255))' | query
[ "$(echo 'SELECT COUNT(*) FROM test' | query)" = 0 ]
echo 'INSERT INTO test VALUES (1, 2, "hello")' | query
[ "$(echo 'SELECT COUNT(*) FROM test' | query)" = 1 ]
echo 'INSERT INTO test VALUES (2, 3, "goodbye!")' | query
[ "$(echo 'SELECT COUNT(*) FROM test' | query)" = 2 ]
echo 'DELETE FROM test WHERE a = 1' | query
[ "$(echo 'SELECT COUNT(*) FROM test' | query)" = 1 ]
[ "$(echo 'SELECT c FROM test' | query)" = 'goodbye!' ]
echo 'DROP TABLE test' | query
