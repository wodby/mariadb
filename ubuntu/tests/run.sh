#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

export MYSQL_ROOT_PASSWORD='password'
export MYSQL_USER='mariadb'
export MYSQL_PASSWORD='mariadb'
export MYSQL_DATABASE='mariadb'
export MYSQL_HOST='mariadb'

# The variable names and drop-in configuration directories of the official
# MariaDB image must work without any MYSQL_* variable: this is what tools
# written for that image, such as Kubernetes operators, pass to the container.
official_conf_dir="$(mktemp -d)"
chmod 755 "${official_conf_dir}"
printf '[mysqld]\nmax_connections = 123\n' > "${official_conf_dir}/test.cnf"
chmod 644 "${official_conf_dir}/test.cnf"
official_cid="$(
	docker run -d \
		-e MARIADB_ROOT_PASSWORD='official-root' \
		-e MARIADB_DATABASE='official' \
		-e MARIADB_USER='official' \
		-e MARIADB_PASSWORD='official-user' \
		-v "${official_conf_dir}:/etc/mysql/conf.d:ro" \
		--name mariadb-official-names \
		"${IMAGE}"
)"
trap "docker rm -vf ${official_cid} > /dev/null; rm -rf ${official_conf_dir}" EXIT

official() {
	docker run --rm -i \
		-e MARIADB_ROOT_PASSWORD='official-root' \
		-e MARIADB_DATABASE='official' \
		-e MARIADB_USER='official' \
		-e MARIADB_PASSWORD='official-user' \
		--link mariadb-official-names \
		"${IMAGE}" \
		"${@}" \
		host=mariadb-official-names
}

official make check-ready delay_seconds=5 wait_seconds=5 max_try=12
[ "$(official make query-silent query='SELECT DATABASE()')" = 'official' ]
[ "$(official make query-silent query='SELECT @@max_connections')" = '123' ]
official make mysql-check
official make create-db name='official_action'
official make drop-db name='official_action'

docker rm -vf "${official_cid}" > /dev/null
rm -rf "${official_conf_dir}"
trap - EXIT

archive_init_dir="$(mktemp -d)"
chmod 755 "${archive_init_dir}"
echo 'CREATE TABLE mariadb.archive_init_test (id INT);' > "${archive_init_dir}/database.sql"
gzip "${archive_init_dir}/database.sql"
chmod 644 "${archive_init_dir}/database.sql.gz"

cid="$(
	docker run -d \
	    -e DEBUG \
		-e MYSQL_ROOT_PASSWORD \
		-e MYSQL_USER \
		-e MYSQL_PASSWORD \
		-e MYSQL_DATABASE \
		-v "${archive_init_dir}:/docker-entrypoint-initdb.d:ro" \
		--name "${MYSQL_HOST}" \
		"${IMAGE}"
)"
trap "docker rm -vf ${cid} > /dev/null; rm -rf ${archive_init_dir}" EXIT

mariadb() {
	docker run --rm -i \
	    -e DEBUG -e MYSQL_USER -e MYSQL_ROOT_PASSWORD -e MYSQL_PASSWORD -e MYSQL_DATABASE \
	    -v /tmp:/mnt/backups \
	    --link "${MYSQL_HOST}":"${MYSQL_HOST}" \
	    "${IMAGE}" \
	    "${@}" \
	    host="${MYSQL_HOST}"
}

mariadb make check-ready delay_seconds=5 wait_seconds=5 max_try=12
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM archive_init_test')" = 0 ]
# The server is MariaDB's own Ubuntu package, not a build of this repository.
mariadb make query-silent query='SELECT @@version' | grep -q -- '-ubu'
mariadb make mysql-upgrade
mariadb make mysql-check

mariadb make create-user username='actionuser' password='action-password'
mariadb make create-user username='actionuser' password='action-password'
if mariadb make create-user username='actionuser' password='unexpected-password'; then
	echo "Create user unexpectedly replaced credentials" >&2
	exit 1
fi
mariadb make grant-user-db username='actionuser' db="${MYSQL_DATABASE}"
[ "$(mariadb make query-silent user='actionuser' password='action-password' query='SELECT 1')" = '1' ]
mariadb make revoke-user-db username='actionuser' db="${MYSQL_DATABASE}"
mariadb make drop-user username='actionuser'

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
mariadb make mysql-check

mariadb make query query="CREATE TABLE cache_this (a INT, b INT, c VARCHAR(255))"
mariadb make query query="CREATE TABLE cache_that (a INT, b INT, c VARCHAR(255))"
mariadb make query query="INSERT INTO cache_this VALUES (1, 2, 'hello')"
mariadb make query query="INSERT INTO cache_that VALUES (1, 2, 'hello')"
mariadb make mysql-check

[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM cache_this')" = 1 ]
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM cache_that')" = 1 ]

mariadb make query query="CREATE TABLE test1 (a INT, b INT, c VARCHAR(255))"
mariadb make query query="CREATE TABLE test2 (a INT, b INT, c VARCHAR(255))"
mariadb make query query="INSERT INTO test1 VALUES (1, 2, 'hello')"
mariadb make query query="INSERT INTO test2 VALUES (1, 2, 'hello!')"
mariadb make mysql-check

mariadb make backup filepath="/mnt/backups/export.sql.gz" ignore="test1;test2;cache_%;test3"
mariadb make query query="DROP DATABASE mariadb"
mariadb make import source="/mnt/backups/export.sql.gz"
mariadb make mysql-check

[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM cache_this')" = 0 ]
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM cache_that')" = 0 ]

[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test')" = 1 ]
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test1')" = 0 ]
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test2')" = 0 ]

stream_dir="$(mktemp -d)"
chmod 777 "${stream_dir}"
docker run --rm \
    -e MYSQL_USER -e MYSQL_ROOT_PASSWORD -e MYSQL_PASSWORD -e MYSQL_DATABASE \
    -v "${stream_dir}:/stream" \
    --link "${MYSQL_HOST}":"${MYSQL_HOST}" \
    "${IMAGE}" bash -ceu '
        mkfifo /stream/data
        touch /stream/status
        chmod 666 /stream/data /stream/status
        cat /stream/data > /stream/export.sql.gz &
        reader=$!
        make -f /usr/local/bin/actions.mk backup-stream \
            host="'"${MYSQL_HOST}"'" \
            ignore="test1;test2;cache_%;test3" \
            stream_path=/stream/data \
            status_path=/stream/status
        wait "${reader}"
        test "$(cat /stream/status)" = 0

        rm /stream/data /stream/status
        mkfifo /stream/data
        touch /stream/status
        chmod 666 /stream/data /stream/status
        cat /stream/data >/dev/null &
        reader=$!
        if make -f /usr/local/bin/actions.mk backup-stream \
            host="'"${MYSQL_HOST}"'" \
            db=missing_stream_backup_database \
            stream_path=/stream/data \
            status_path=/stream/status; then
            exit 1
        fi
        wait "${reader}"
        test "$(cat /stream/status)" != 0
    '
docker run --rm -i \
    -e DEBUG -e MYSQL_USER -e MYSQL_ROOT_PASSWORD -e MYSQL_PASSWORD -e MYSQL_DATABASE \
    -v "${stream_dir}:/stream" \
    --link "${MYSQL_HOST}":"${MYSQL_HOST}" \
    "${IMAGE}" \
    make import source=/stream/export.sql.gz host="${MYSQL_HOST}"
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test')" = 1 ]
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test1')" = 0 ]
[ "$(mariadb make query-silent query='SELECT COUNT(*) FROM test2')" = 0 ]
rm -rf "${stream_dir}"

mariadb make import source="https://s3.amazonaws.com/wodby-sample-files/mariadb-import-test/export.zip"
mariadb make import source="https://s3.amazonaws.com/wodby-sample-files/mariadb-import-test/export.tar.gz"
mariadb make mysql-check

# Galera: a node bootstraps a cluster and a second one joins it with a full
# state transfer. The joiner starts from an empty data directory, so this also
# covers initialization on a joining node and the tools the transfer scripts
# need. Rows written on either node must then be readable on the other.
galera_net="mariadb-galera-test-$$"
galera_subnet='172.31.251'
docker network create --subnet "${galera_subnet}.0/24" "${galera_net}" > /dev/null
galera_conf_dir="$(mktemp -d)"
chmod 755 "${galera_conf_dir}"

# Docker can still be detaching a removed container when the network is
# removed, so that is tried twice. The exit trap does all the cleanup.
trap "docker rm -vf ${cid} ${galera_net}-1 ${galera_net}-2 > /dev/null 2>&1; docker network rm ${galera_net} > /dev/null 2>&1 || { sleep 3; docker network rm ${galera_net} > /dev/null 2>&1; }; rm -rf ${archive_init_dir} ${galera_conf_dir}" EXIT

galera_node() {
	local n="$1"; shift
	mkdir "${galera_conf_dir}/${n}"
	chmod 755 "${galera_conf_dir}/${n}"
	cat > "${galera_conf_dir}/${n}/galera.cnf" <<-EOCNF
		[mariadb]
		wsrep_on = ON
		wsrep_provider = /usr/lib/galera/libgalera_smm.so
		wsrep_cluster_name = test
		wsrep_cluster_address = gcomm://${galera_subnet}.11,${galera_subnet}.12
		wsrep_node_address = ${galera_subnet}.1${n}
		wsrep_node_name = node${n}
		wsrep_sst_method = mariabackup
		wsrep_sst_auth = root:${MYSQL_ROOT_PASSWORD}
		binlog_format = ROW
		innodb_autoinc_lock_mode = 2
	EOCNF
	chmod 644 "${galera_conf_dir}/${n}/galera.cnf"
	docker run -d \
		--network "${galera_net}" --ip "${galera_subnet}.1${n}" \
		--name "${galera_net}-${n}" \
		-e MYSQL_ROOT_PASSWORD \
		-v "${galera_conf_dir}/${n}:/etc/mysql/conf.d:ro" \
		"${IMAGE}" "$@" > /dev/null
}

galera_sql() {
	local n="$1"; shift
	docker exec "${galera_net}-${n}" mariadb -uroot -p"${MYSQL_ROOT_PASSWORD}" --batch --skip-column-names -e "$@"
}

galera_wait() {
	local n="$1" size="$2" i
	for i in $(seq 1 60); do
		if [ "$(galera_sql "${n}" "SELECT CONCAT((SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS WHERE VARIABLE_NAME='wsrep_cluster_size'), '/', (SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS WHERE VARIABLE_NAME='wsrep_local_state_comment'))" 2>/dev/null)" = "${size}/Synced" ]; then
			return 0
		fi
		sleep 3
	done
	docker logs "${galera_net}-${n}" 2>&1 | tail -n 60 >&2
	echo "Galera node ${n} did not reach a synced cluster of ${size}" >&2
	return 1
}

galera_node 1 mariadbd --wsrep-new-cluster
galera_wait 1 1
galera_sql 1 "CREATE DATABASE galera; CREATE TABLE galera.t (id INT AUTO_INCREMENT PRIMARY KEY, node VARCHAR(8)); INSERT INTO galera.t (node) VALUES ('node1')"
galera_node 2 mariadbd
galera_wait 2 2
galera_wait 1 2
[ "$(galera_sql 2 'SELECT node FROM galera.t')" = 'node1' ]
galera_sql 2 "INSERT INTO galera.t (node) VALUES ('node2')"
[ "$(galera_sql 1 'SELECT COUNT(*) FROM galera.t')" = 2 ]
docker run --rm "${IMAGE}" garbd --version > /dev/null 2>&1
