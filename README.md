# Generic MariaDB docker container image

[![Build Status](https://travis-ci.org/wodby/mariadb.svg?branch=master)](https://travis-ci.org/wodby/mariadb)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)

[![Wodby Slack](https://www.google.com/s2/favicons?domain=www.slack.com) Join us on Slack](https://slack.wodby.com/)

## Supported tags and respective `Dockerfile` links:

- [`10.1-2.0.0`, `10.1`, `latest` (*10.1/Dockerfile*)](https://github.com/wodby/mariadb/tree/master/10.1/Dockerfile)

## Environment Variables Available for Customization

| Environment Variable | Type | Default Value | Description |
| -------------------- | -----| ------------- | ----------- |
| MYSQL_BACK_LOG                        | Numeric | 100                                        | |
| MYSQL_CHARACTER_SET_SERVER            | String  | utf8                                       | |
| MYSQL_CHARACTER_SET_FILESYSTEM        | String  | utf8                                       | |
| MYSQL_COLLATION_SERVER                | String  | utf8_unicode_ci                            | |
| MYSQL_DATABASE                        | String  |                                            | |
| MYSQL_DEFAULT_CHARACTER_SET           | String  | utf8                                       | | 
| MYSQL_DUMP_MAX_ALLOWED_PACKET         | String  | 1G                                         | |
| MYSQL_GENERAL_LOG                     | Numeric | 1                                          | |
| MYSQL_INIT_CONNECT                    | String  | SET collation_connection = utf8_general_ci | |
| MYSQL_INNODB_BUFFER_POOL_SIZE         | String  | 1G                                         | |
| MYSQL_INNODB_BUFFER_POOL_INSTANCES    | Numeric | 4                                          | |
| MYSQL_INNODB_DATA_FILE_PATH           | String  | ibdata1:10M:autoextend:max:10G             | |
| MYSQL_INNODB_FILE_FORMAT              | String  | barracuda                                  | |
| MYSQL_INNODB_FILE_PER_TABLE           | Boolean | 1                                          | |
| MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT  | Numeric | 2                                          | |
| MYSQL_INNODB_FLUSH_METHOD             | String  | O_DIRECT                                   | |
| MYSQL_INNODB_IO_CAPACITY              | Numeric | 200                                        | |
| MYSQL_INNODB_LARGE_PREFIX             | String  | true                                       | |
| MYSQL_INNODB_LOCK_WAIT_TIMEOUT        | Numeric | 50                                         | |
| MYSQL_INNODB_LOG_BUFFER_SIZE          | String  | 8M                                         | |
| MYSQL_INNODB_LOG_FILE_SIZE            | String  | 128M                                       | |
| MYSQL_INNODB_LOG_FILES_IN_GROUP       | Numeric | 2                                          | |
| MYSQL_INNODB_OLD_BLOCKS_TIME          | Numeric | 1000                                       | |
| MYSQL_INNODB_OPEN_FILES               | Numeric | 1024                                       | |
| MYSQL_INNODB_READ_IO_THREADS          | Numeric | 4                                          | |
| MYSQL_INNODB_STATS_ON_METADATA        | Boolean | OFF                                        | |
| MYSQL_INNODB_STRICT_MODE              | Numeric | 0                                          | |
| MYSQL_INNODB_WRITE_IO_THREADS         | Numeric | 4                                          | |
| MYSQL_INTERACTIVE_TIMEOUT             | Numeric | 420                                        | |
| MYSQL_JOIN_BUFFER_SIZE                | String  | 8M                                         | |
| MYSQL_KEY_BUFFER_SIZE                 | String  | 32M                                        | |
| MYSQL_LONG_QUERY_TIME                 | Numeric | 2                                          | |
| MYSQL_MAX_ALLOWED_PACKET              | String  | 16M                                        | |
| MYSQL_MAX_CONNECT_ERRORS              | Numeric | 100000                                     | |
| MYSQL_MAX_CONNECTIONS                 | Numeric | 50                                         | |
| MYSQL_MAX_HEAP_TABLE_SIZE             | String  | 16M                                        | |
| MYSQL_NET_WRITE_TIMEOUT               | Numeric | 90                                         | |
| MYSQL_NET_READ_TIMEOUT                | Numeric | 90                                         | |
| MYSQL_PASSWORD                        | String  |                                            | |
| MYSQL_PERFORMANCE_SCHEMA              | Boolean | 0                                          | |
| MYSQL_PORT                            | Numeric | 3306                                       | |
| MYSQL_ROOT_PASSWORD                   | String  |                                            | REQUIRED |
| MYSQL_QUERY_CACHE_TYPE                | Enum    | 1                                          | |
| MYSQL_QUERY_CACHE_MIN_RES_UNIT        | String  | 2K                                         | |
| MYSQL_QUERY_CACHE_SIZE                | String  | 128M                                       | |
| MYSQL_QUERY_CACHE_LIMIT               | String  | 256K                                       | |
| MYSQL_SLOW_QUERY_LOG                  | Numeric | 0                                          | |
| MYSQL_SORT_BUFFER_SIZE                | String  | 1M                                         | |
| MYSQL_TABLE_DEFINITION_CACHE          | String  | 400                                        | |
| MYSQL_TABLE_OPEN_CACHE                | String  | 4096                                       | |
| MYSQL_THREAD_CACHE_SIZE               | Numeric | 75                                         | |
| MYSQL_TMP_TABLE_SIZE                  | String  | 16M                                        | |
| MYSQL_USER                            | String  |                                            | |
| MYSQL_WAIT_TIMEOUT                    | Numeric | 420                                        | |

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
    max_try 12
    wait_seconds = 5
    ignore ""
```

Examples:

```bash
# Check if MariaDB is ready
docker exec -ti [ID] make check-ready -f /usr/local/bin/Makefile

# Run query
docker exec -ti [ID] make query query="CREATE TABLE test (a Numeric, b Numeric, c VARCHAR(255))" -f /usr/local/bin/actions.mk

# Backup default database
docker exec -ti [ID] make backup filepath="/path/to/mounted/dir/backup.sql.gz" -f /usr/local/bin/actions.mk

# Import from file
docker exec -ti [ID] make import source="/path/to/mounted/dir/export.sql.gz" -f /usr/local/bin/actions.mk

# Import from URL
docker exec -ti [ID] make import source="https://example.com/url/to/sql/dump.zip" -f /usr/local/bin/actions.mk
```

## Using in Production

Deploy MariaDB container to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).
