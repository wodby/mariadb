# Generic MariaDB docker container

[![Build Status](https://travis-ci.org/wodby/mariadb.svg?branch=master)](https://travis-ci.org/wodby/mariadb)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/mariadb.svg)](https://hub.docker.com/r/wodby/mariadb)

## Supported tags and respective `Dockerfile` links:

- [`10.1`, `latest` (*10.1/Dockerfile*)](https://github.com/wodby/mariadb/tree/master/10.1/Dockerfile)

## Environment Variables Available for Customization

| Environment Variable | Type | Default Value | Description |
| -------------------- | -----| ------------- | ----------- |
| MYSQL_ROOT_PASSWORD                   | String |                                            | REQUIRED |
| MYSQL_USER                            | String |                                            | |
| MYSQL_PASSWORD                        | String |                                            | |
| MYSQL_DATABASE                        | String |                                            | |
| MYSQL_DUMP_MAX_ALLOWED_PACKET         | String | 1G                                         | |
| MYSQL_PORT                            | Int    | 3306                                       | |
| MYSQL_DEFAULT_CHARACTER_SET           | String | utf8                                       | | 
| MYSQL_INNODB_FILE_FORMAT              | String | barracuda                                  | |
| MYSQL_COLLATION_SERVER                | String | utf8_unicode_ci                            | |
| MYSQL_INIT_CONNECT                    | String | SET NAMES utf8                             | |
| MYSQL_INIT_CONNECT                    | String | SET collation_connection = utf8_general_ci | |
| MYSQL_CHARACTER_SET_SERVER            | String | utf8                                       | |
| MYSQL_CHARACTER_SET_FILESYSTEM        | String | utf8                                       | |
| MYSQL_QUERY_CACHE_SIZE                | String | 8M                                         | |
| MYSQL_QUERY_CACHE_LIMIT               | String | 2M                                         | |
| MYSQL_TABLE_OPEN_CACHE                | String | 1024                                       | |
| MYSQL_TMP_TABLE_SIZE                  | String | 16M                                        | |
| MYSQL_KEY_BUFFER_SIZE                 | String | 32M                                        | |
| MYSQL_MAX_ALLOWED_PACKET              | String | 256M                                       | |
| MYSQL_MAX_CONNECTIONS                 | Int    | 50                                         | |
| MYSQL_INNODB_FILE_PER_TABLE           | String | true                                       | |
| MYSQL_INNODB_FILE_FORMAT              | String | barracuda                                  | |
| MYSQL_INNODB_LARGE_PREFIX             | String | true                                       | |
| MYSQL_INNODB_STRICT_MODE              | Int    | 0                                          | |
| MYSQL_INNODB_OPEN_FILES               | Int    | 1024                                       | |
| MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT  | Int    | 2                                          | |
| MYSQL_INNODB_BUFFER_POOL_SIZE         | String | 1G                                         | |
| MYSQL_INNODB_LOG_BUFFER_SIZE          | String | 8M                                         | |
| MYSQL_INNODB_LOG_FILE_SIZE            | String | 32M                                        | |
| MYSQL_LONG_QUERY_TIME                 | Int    | 2                                          | |
| MYSQL_SLOW_QUERY_LOG                  | Int    | 0                                          | |
| MYSQL_GENERAL_LOG                     | Int    | 1                                          | |
| MYSQL_QUERY_CACHE_TYPE                | String | Off                                        | |
