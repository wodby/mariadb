# MariaDB docker container image

[![Build Status](https://travis-ci.org/wodby/mariadb.svg?branch=master)](https://travis-ci.org/wodby/mariadb)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Supported tags and respective `Dockerfile` links:

- [`10.1-2.2.0`, `10.1`, `latest` (*10.1/Dockerfile*)](https://github.com/wodby/mariadb/tree/master/10.1/Dockerfile)

## Environment variables available for customization

| Environment Variable | Default Value | Description |
| -------------------- | ------------- | ----------- |
| MYSQL_BACK_LOG                        | 100                                        | |
| MYSQL_CHARACTER_SET_SERVER            | utf8                                       | |
| MYSQL_CHARACTER_SET_FILESYSTEM        | utf8                                       | |
| MYSQL_COLLATION_SERVER                | utf8_unicode_ci                            | |
| MYSQL_DATABASE                        |                                            | |
| MYSQL_DEFAULT_CHARACTER_SET           | utf8                                       | | 
| MYSQL_DUMP_MAX_ALLOWED_PACKET         | 1G                                         | |
| MYSQL_GENERAL_LOG                     | 1                                          | |
| MYSQL_INIT_CONNECT                    | SET collation_connection = utf8_general_ci | |
| MYSQL_INNODB_BUFFER_POOL_SIZE         | 1G                                         | |
| MYSQL_INNODB_BUFFER_POOL_INSTANCES    | 4                                          | |
| MYSQL_INNODB_DATA_FILE_PATH           | ibdata1:10M:autoextend:max:10G             | |
| MYSQL_INNODB_FILE_FORMAT              | barracuda                                  | |
| MYSQL_INNODB_FILE_PER_TABLE           | 1                                          | |
| MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT  | 2                                          | |
| MYSQL_INNODB_FLUSH_METHOD             | O_DIRECT                                   | |
| MYSQL_INNODB_IO_CAPACITY              | 200                                        | |
| MYSQL_INNODB_LARGE_PREFIX             | true                                       | |
| MYSQL_INNODB_LOCK_WAIT_TIMEOUT        | 50                                         | |
| MYSQL_INNODB_LOG_BUFFER_SIZE          | 8M                                         | |
| MYSQL_INNODB_LOG_FILE_SIZE            | 128M                                       | |
| MYSQL_INNODB_LOG_FILES_IN_GROUP       | 2                                          | |
| MYSQL_INNODB_OLD_BLOCKS_TIME          | 1000                                       | |
| MYSQL_INNODB_OPEN_FILES               | 1024                                       | |
| MYSQL_INNODB_READ_IO_THREADS          | 4                                          | |
| MYSQL_INNODB_STATS_ON_METADATA        | OFF                                        | |
| MYSQL_INNODB_STRICT_MODE              | 0                                          | |
| MYSQL_INNODB_WRITE_IO_THREADS         | 4                                          | |
| MYSQL_INTERACTIVE_TIMEOUT             | 420                                        | |
| MYSQL_JOIN_BUFFER_SIZE                | 8M                                         | |
| MYSQL_KEY_BUFFER_SIZE                 | 32M                                        | |
| MYSQL_LONG_QUERY_TIME                 | 2                                          | |
| MYSQL_MAX_ALLOWED_PACKET              | 16M                                        | |
| MYSQL_MAX_CONNECT_ERRORS              | 100000                                     | |
| MYSQL_MAX_CONNECTIONS                 | 50                                         | |
| MYSQL_MAX_HEAP_TABLE_SIZE             | 16M                                        | |
| MYSQL_NET_WRITE_TIMEOUT               | 90                                         | |
| MYSQL_NET_READ_TIMEOUT                | 90                                         | |
| MYSQL_PASSWORD                        |                                            | |
| MYSQL_PERFORMANCE_SCHEMA              | 0                                          | |
| MYSQL_PORT                            | 3306                                       | |
| MYSQL_ROOT_PASSWORD                   |                                            | REQUIRED |
| MYSQL_QUERY_CACHE_TYPE                | 1                                          | |
| MYSQL_QUERY_CACHE_MIN_RES_UNIT        | 2K                                         | |
| MYSQL_QUERY_CACHE_SIZE                | 128M                                       | |
| MYSQL_QUERY_CACHE_LIMIT               | 256K                                       | |
| MYSQL_SLOW_QUERY_LOG                  | 0                                          | |
| MYSQL_SORT_BUFFER_SIZE                | 1M                                         | |
| MYSQL_TABLE_DEFINITION_CACHE          | 400                                        | |
| MYSQL_TABLE_OPEN_CACHE                | 4096                                       | |
| MYSQL_THREAD_CACHE_SIZE               | 75                                         | |
| MYSQL_TMP_TABLE_SIZE                  | 16M                                        | |
| MYSQL_USER                            |                                            | |
| MYSQL_WAIT_TIMEOUT                    | 420                                        | |

## Actions

Usage:
```
make COMMAND [params ...]
 
commands:
    import source=</path/to/dump.zip or http://example.com/url/to/dump.sql.gz> [db root_password host ignore="table1;table2"] 
    backup filepath=</path/to/backup.sql.gz> [root_password host db] 
    query query=<SELECT 1> [db user password host] 
    query-silent query=<SELECT 1> [db user password host] 
    query-root query=<SELECT 1> [db root_password host]
    check-ready [root_password host max_try wait_seconds]  
    
default params values:
    user $MYSQL_USER
    password $MYSQL_PASSWORD
    db $MYSQL_DATABASE
    root_password $MYSQL_ROOT_PASSWORD
    host localhost
    max_try 1
    wait_seconds 1
    ignore ""
```

Examples:

```bash
# Check if MariaDB is ready
docker exec -ti [ID] make check-ready wait_seconds=5 max_try=12 -f /usr/local/bin/Makefile

# Run query
docker exec -ti [ID] make query query="CREATE TABLE test (a Numeric, b Numeric, c VARCHAR(255))" -f /usr/local/bin/actions.mk

# Backup default database
docker exec -ti [ID] make backup filepath="/path/to/mounted/dir/backup.sql.gz" -f /usr/local/bin/actions.mk

# Import from file
docker exec -ti [ID] make import source="/path/to/mounted/dir/export.sql.gz" -f /usr/local/bin/actions.mk

# Import from URL
docker exec -ti [ID] make import source="https://example.com/url/to/sql/dump.zip" -f /usr/local/bin/actions.mk
```

## Using in production

Deploy MariaDB container to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).
