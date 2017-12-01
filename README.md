# MariaDB Docker Container Image

[![Build Status](https://travis-ci.org/wodby/mariadb.svg?branch=master)](https://travis-ci.org/wodby/mariadb)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/mariadb.svg)](https://microbadger.com/images/wodby/mariadb)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

* All images are based on Alpine Linux
* Base image: [wodby/alpine](https://github.com/wodby/alpine)
* [Travis CI builds](https://travis-ci.org/wodby/mariadb) 
* [Docker Hub](https://hub.docker.com/r/wodby/mariadb)

Supported tags and respective `Dockerfile` links:

* `10`, `10.2`, `latest` [_(Dockerfile)_](https://github.com/wodby/mariadb/tree/master/10/Dockerfile)
* `10.1` [_(Dockerfile)_](https://github.com/wodby/mariadb/tree/master/10/Dockerfile)

For better reliability we additionally release images with stability tags (`wodby/mariadb:10.1-X.X.X`) which correspond to [git tags](https://github.com/wodby/mariadb/releases). We **strongly recommend** using images only with stability tags. 

## Environment Variables

[MYSQL_BACK_LOG]: https://mariadb.com/kb/en/library/server-system-variables/#back_log
[MYSQL_CHARACTER_SET_FILESYSTEM]: https://mariadb.com/kb/en/library/server-system-variables/#character_set_filesystem 
[MYSQL_CHARACTER_SET_SERVER]: https://mariadb.com/kb/en/library/server-system-variables/#character_set_server 
[MYSQL_COLLATION_SERVER]: https://mariadb.com/kb/en/library/server-system-variables/#collation_server
[MYSQL_DEFAULT_STORAGE_ENGINE]: https://mariadb.com/kb/en/library/server-system-variables/#default_storage_engine
[MYSQL_GENERAL_LOG]: https://mariadb.com/kb/en/library/server-system-variables/#general_log
[MYSQL_INIT_CONNECT]: https://mariadb.com/kb/en/library/server-system-variables/#init_connect
[MYSQL_INNODB_BUFFER_POOL_INSTANCES]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_buffer_pool_instances
[MYSQL_INNODB_BUFFER_POOL_SIZE]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_buffer_pool_size
[MYSQL_INNODB_DATA_FILE_PATH]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_data_file_path
[MYSQL_INNODB_FAST_SHUTDOWN]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_fast_shutdown
[MYSQL_INNODB_FILE_FORMAT]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_file_format
[MYSQL_INNODB_FILE_PER_TABLE]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_file_per_table
[MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_flush_log_at_trx_commit
[MYSQL_INNODB_FLUSH_METHOD]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_flush_method
[MYSQL_INNODB_FORCE_LOAD_CORRUPTED]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_force_load_corrupted
[MYSQL_INNODB_IO_CAPACITY]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_io_capacity
[MYSQL_INNODB_LARGE_PREFIX]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_large_prefix
[MYSQL_INNODB_LOCK_WAIT_TIMEOUT]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_lock_wait_timeout
[MYSQL_INNODB_LOG_BUFFER_SIZE]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_log_buffer_size
[MYSQL_INNODB_LOG_FILE_SIZE]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_log_file_size
[MYSQL_INNODB_LOG_FILES_IN_GROUP]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_log_files_in_group
[MYSQL_INNODB_OLD_BLOCKS_TIME]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_old_blocks_time
[MYSQL_INNODB_OPEN_FILES]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_open_files
[MYSQL_INNODB_READ_IO_THREADS]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_read_io_threads
[MYSQL_INNODB_STATS_ON_METADATA]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_stats_on_metadata
[MYSQL_INNODB_STRICT_MODE]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_strict_mode
[MYSQL_INNODB_WRITE_IO_THREADS]: https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_write_io_threads
[MYSQL_INTERACTIVE_TIMEOUT]: https://mariadb.com/kb/en/library/server-system-variables/#interactive_timeout
[MYSQL_JOIN_BUFFER_SIZE]: https://mariadb.com/kb/en/library/server-system-variables/#join_buffer_size
[MYSQL_LONG_QUERY_TIME]: https://mariadb.com/kb/en/library/server-system-variables/#long_query_time
[MYSQL_MAX_ALLOWED_PACKET]: https://mariadb.com/kb/en/library/server-system-variables/#max_allowed_packet
[MYSQL_MAX_CONNECT_ERRORS]: https://mariadb.com/kb/en/library/server-system-variables/#max_connect_errors
[MYSQL_MAX_CONNECTIONS]: https://mariadb.com/kb/en/library/server-system-variables/#max_connections
[MYSQL_MAX_HEAP_TABLE_SIZE]: https://mariadb.com/kb/en/library/server-system-variables/#max_heap_table_size
[MYSQL_NET_READ_TIMEOUT]: https://mariadb.com/kb/en/library/server-system-variables/#net_read_timeout
[MYSQL_NET_WRITE_TIMEOUT]: https://mariadb.com/kb/en/library/server-system-variables/#net_write_timeout
[MYSQL_PERFORMANCE_SCHEMA]: https://mariadb.com/kb/en/library/performance-schema-system-variables/#performance_schema
[MYSQL_QUERY_CACHE_LIMIT]: https://mariadb.com/kb/en/library/server-system-variables/#query_cache_limit
[MYSQL_QUERY_CACHE_MIN_RES_UNIT]: https://mariadb.com/kb/en/library/server-system-variables/#query_cache_min_res_unit
[MYSQL_QUERY_CACHE_SIZE]: https://mariadb.com/kb/en/library/server-system-variables/#query_cache_size
[MYSQL_QUERY_CACHE_TYPE]: https://mariadb.com/kb/en/library/server-system-variables/#query_cache_type
[MYSQL_RELAY_LOG_RECOVERY]: https://mariadb.com/kb/en/library/replication-and-binary-log-server-system-variables/#relay_log_recovery
[MYSQL_SLOW_QUERY_LOG]: https://mariadb.com/kb/en/library/server-system-variables/#slow_query_log
[MYSQL_SORT_BUFFER_SIZE]: https://mariadb.com/kb/en/library/server-system-variables/#sort_buffer_size
[MYSQL_TABLE_DEFINITION_CACHE]: https://mariadb.com/kb/en/library/server-system-variables/#table_definition_cache
[MYSQL_TABLE_OPEN_CACHE]: https://mariadb.com/kb/en/library/server-system-variables/#table_open_cache
[MYSQL_THREAD_CACHE_SIZE]: https://mariadb.com/kb/en/library/server-system-variables/#thread_cache_size
[MYSQL_TMP_TABLE_SIZE]: https://mariadb.com/kb/en/library/server-system-variables/#tmp_table_size
[MYSQL_WAIT_TIMEOUT]: https://mariadb.com/kb/en/library/server-system-variables/#wait_timeout

| Variable                               | 10.2                           | 10.1                           |
| -------------------------------------- | ------------------------------ | ------------------------------ |
| [MYSQL_BACK_LOG]                       | 100                            | 100                            |
| [MYSQL_CHARACTER_SET_FILESYSTEM]       | utf8                           | utf8                           |
| [MYSQL_CHARACTER_SET_SERVER]           | utf8                           | utf8                           |
| MYSQL_CLIENT_DEFAULT_CHARACTER_SET     | utf8                           | utf8                           |
| [MYSQL_COLLATION_SERVER]               | utf8_unicode_ci                | utf8_unicode_ci                |
| MYSQL_DATABASE                         |                                |                                |
| [MYSQL_DEFAULT_STORAGE_ENGINE]         | InnoDB                         | InnoDB                         |
| MYSQL_DUMP_MAX_ALLOWED_PACKET          | 1G                             | 1G                             |
| [MYSQL_GENERAL_LOG]                    | 1                              | 1                              |
| [MYSQL_INIT_CONNECT]                   | SET NAMES utf8                 | SET NAMES utf8                 |
| [MYSQL_INNODB_BUFFER_POOL_INSTANCES]   | 4                              | 4                              |
| [MYSQL_INNODB_BUFFER_POOL_SIZE]        | 1G                             | 1G                             |
| [MYSQL_INNODB_DATA_FILE_PATH]          | ibdata1:10M:autoextend:max:10G | ibdata1:10M:autoextend:max:10G |
| [MYSQL_INNODB_FAST_SHUTDOWN]           | 1                              | 1                              |
| [MYSQL_INNODB_FILE_FORMAT]             | -                              | barracuda                      |
| [MYSQL_INNODB_FILE_PER_TABLE]          | 1                              | 1                              |
| [MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT] | 2                              | 2                              |
| [MYSQL_INNODB_FLUSH_METHOD]            | O_DIRECT                       | O_DIRECT                       |
| [MYSQL_INNODB_FORCE_LOAD_CORRUPTED]    | 0                              | 0                              |
| [MYSQL_INNODB_IO_CAPACITY]             | 200                            | 200                            |
| [MYSQL_INNODB_LARGE_PREFIX]            | -                              | true                           |
| [MYSQL_INNODB_LOCK_WAIT_TIMEOUT]       | 50                             | 50                             |
| [MYSQL_INNODB_LOG_BUFFER_SIZE]         | 8M                             | 8M                             |
| [MYSQL_INNODB_LOG_FILE_SIZE]           | 128M                           | 128M                           |
| [MYSQL_INNODB_LOG_FILES_IN_GROUP]      | 2                              | 2                              |
| [MYSQL_INNODB_OLD_BLOCKS_TIME]         | 1000                           | 1000                           |
| [MYSQL_INNODB_OPEN_FILES]              | 1024                           | 1024                           |
| [MYSQL_INNODB_READ_IO_THREADS]         | 4                              | 4                              |
| [MYSQL_INNODB_STATS_ON_METADATA]       | OFF                            | OFF                            |
| [MYSQL_INNODB_STRICT_MODE]             | OFF                            | OFF                            |
| [MYSQL_INNODB_WRITE_IO_THREADS]        | 4                              | 4                              |
| [MYSQL_INTERACTIVE_TIMEOUT]            | 420                            | 420                            |
| [MYSQL_JOIN_BUFFER_SIZE]               | 8M                             | 8M                             |
| [MYSQL_LONG_QUERY_TIME]                | 2                              | 2                              |
| [MYSQL_MAX_ALLOWED_PACKET]             | 256M                           | 256M                           |
| [MYSQL_MAX_CONNECT_ERRORS]             | 100000                         | 100000                         |
| [MYSQL_MAX_CONNECTIONS]                | 50                             | 50                             |
| [MYSQL_MAX_HEAP_TABLE_SIZE]            | 16M                            | 16M                            |
| [MYSQL_NET_READ_TIMEOUT]               | 90                             | 90                             |
| [MYSQL_NET_WRITE_TIMEOUT]              | 90                             | 90                             |
| MYSQL_PASSWORD                         |                                |                                |
| [MYSQL_PERFORMANCE_SCHEMA]             | OFF                            | OFF                            |
| MYSQL_PORT                             | 3306                           | 3306                           |
| [MYSQL_QUERY_CACHE_LIMIT]              | 1M                             | 1M                             |
| [MYSQL_QUERY_CACHE_MIN_RES_UNIT]       | 2K                             | 2K                             |
| [MYSQL_QUERY_CACHE_SIZE]               | 128M                           | 128M                           |
| [MYSQL_QUERY_CACHE_TYPE]               | ON                             | ON                             |
| [MYSQL_RELAY_LOG_RECOVERY]             | 0                              | 0                              |
| MYSQL_ROOT_PASSWORD                    |                                |                                |
| [MYSQL_SLOW_QUERY_LOG]                 | 0                              | 0                              |
| [MYSQL_SORT_BUFFER_SIZE]               | 2M                             | 2M                             |
| [MYSQL_TABLE_DEFINITION_CACHE]         | 400                            | 400                            |
| [MYSQL_TABLE_OPEN_CACHE]               | 4096                           | 4096                           |
| [MYSQL_THREAD_CACHE_SIZE]              | 75                             | 75                             |
| [MYSQL_TMP_TABLE_SIZE]                 | 16M                            | 16M                            |
| MYSQL_USER                             |                                |                                |
| [MYSQL_WAIT_TIMEOUT]                   | 420                            | 420                            |

> "-" - Not available for this version

## Orchestration Actions

Usage:
```
make COMMAND [params ...]
 
commands:
    import source=</path/to/dump.zip or http://example.com/url/to/dump.sql.gz> [db root_password host ignore="table1;table2;cache_%"] 
    backup filepath=</path/to/backup.sql.gz> [root_password host db nice ionice] 
    query query [db user password host] 
    query-silent query [db user password host] 
    query-root query [db root_password host]
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
    nice 10
    ionice 7
```

## Deployment

Deploy MariaDB to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://cloud.wodby.com/stackhub/3aa42a7c-db8b-40e9-aa3c-06218724fae6/overview).
