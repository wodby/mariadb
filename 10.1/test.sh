#!/bin/bash

set -e

#if [[ ! -z $DEBUG ]]; then
  set -x
#fi

export MYSQL_ROOT_PASSWORD='password'
export MYSQL_USER='mariadb'
export MYSQL_PASSWORD='mariadb'
export MYSQL_DATABASE='mariadb'
export MYSQL_HOST='mariadb'

cid="$(
	docker run -d \
		-e MYSQL_ROOT_PASSWORD \
		-e MYSQL_USER \
		-e MYSQL_PASSWORD \
		-e MYSQL_DATABASE \
		--name "$NAME" \
		"$IMAGE"
)"
trap "docker rm -vf $cid > /dev/null" EXIT

mariadb() {
	docker run --rm -i \
	    -e MYSQL_USER -e MYSQL_ROOT_PASSWORD -e MYSQL_PASSWORD -e MYSQL_DATABASE \
	    --link "$NAME":"$MYSQL_HOST" \
	    "$IMAGE" \
	    "$@" \
	    host=$MYSQL_HOST
}

mariadb make check-ready
mariadb make query query="CREATE TABLE test (a INT, b INT, c VARCHAR(255))"
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test')" = 0 ]
mariadb make query query="INSERT INTO test VALUES (1, 2, 'hello')"
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test')" = 1 ]
mariadb make query query="INSERT INTO test VALUES (2, 3, 'goodbye!')"
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test')" = 2 ]
mariadb make query query="DELETE FROM test WHERE a = 1"
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test')" = 1 ]
mariadb make query query="DELETE FROM test WHERE a = 1"
[ "$(mariadb make query-silent query='SELECT c FROM test')" = 'goodbye!' ]
mariadb make query query="DELETE FROM test WHERE a = 1"
mariadb make query query="DROP TABLE test"
