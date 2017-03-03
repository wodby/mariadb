[mysqld_safe]

[mysqldump]
quick
quote-names
max_allowed_packet                      = {{ getenv "MYSQL_DUMP_MAX_ALLOWED_PACKET" "1G" }}

[myisamchk]

[mysqlhotcopy]
interactive-timeout

[client]
port                                    = {{ getenv "MYSQL_PORT" "3306" }}
socket                                  = /var/run/mysqld/mysqld.sock
default-character-set                   = {{ getenv "MYSQL_DEFAULT_CHARACTER_SET" "utf8" }}

[mariadb]
innodb_file_format                      = {{ getenv "MYSQL_INNODB_FILE_FORMAT" "barracuda" }}

[mysqld]
user                                    = mysql
bind-address                            = 0.0.0.0
basedir                                 = /usr
datadir                                 = /var/lib/mysql
socket                                  = /var/run/mysqld/mysqld.sock
log-warnings

collation-server                        = {{ getenv "MYSQL_COLLATION_SERVER" "utf8_unicode_ci" }}
init-connect                            = '{{ getenv "MYSQL_INIT_CONNECT" "SET NAMES utf8" }}';
init_connect                            = '{{ getenv "MYSQL_INIT_CONNECT" "SET collation_connection = utf8_general_ci" }}'
character-set-server                    = {{ getenv "MYSQL_CHARACTER_SET_SERVER" "utf8" }}
character_set_filesystem                = {{ getenv "MYSQL_CHARACTER_SET_FILESYSTEM" "utf8" }}

symbolic-links                          = 0
default_storage_engine                  = InnoDB
skip-character-set-client-handshake
skip-name-resolve

query_cache_type                        = {{ getenv "MYSQL_QUERY_CACHE_TYPE" "0" }}
query_cache_min_res_unit                = {{ getenv "MYSQL_QUERY_CACHE_MIN_RES_UNIT" "2K" }}
query_cache_size                        = {{ getenv "MYSQL_QUERY_CACHE_SIZE" "128M" }}
query_cache_limit                       = {{ getenv "MYSQL_QUERY_CACHE_LIMIT" "256K" }}
table_open_cache                        = {{ getenv "MYSQL_TABLE_OPEN_CACHE" "1024" }}
tmp_table_size                          = {{ getenv "MYSQL_TMP_TABLE_SIZE" "16M" }}
key_buffer_size                         = {{ getenv "MYSQL_KEY_BUFFER_SIZE" "32M" }}

max_allowed_packet                      = {{ getenv "MYSQL_MAX_ALLOWED_PACKET" "256M" }}
max_connections                         = {{ getenv "MYSQL_MAX_CONNECTIONS" "50" }}

innodb_file_per_table                   = {{ getenv "MYSQL_INNODB_FILE_PER_TABLE" "true" }}
innodb_file_format                      = {{ getenv "MYSQL_INNODB_FILE_FORMAT" "barracuda" }}
innodb_large_prefix                     = {{ getenv "MYSQL_INNODB_LARGE_PREFIX" "true" }}
innodb_strict_mode                      = {{ getenv "MYSQL_INNODB_STRICT_MODE" "0" }}
innodb_open_files                       = {{ getenv "MYSQL_INNODB_OPEN_FILES" "1024" }}
innodb_flush_log_at_trx_commit          = {{ getenv "MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT" "2" }}
innodb_buffer_pool_size                 = {{ getenv "MYSQL_INNODB_BUFFER_POOL_SIZE" "1G" }}
innodb_log_buffer_size                  = {{ getenv "MYSQL_INNODB_LOG_BUFFER_SIZE" "8M" }}
innodb_log_file_size                    = {{ getenv "MYSQL_INNODB_LOG_FILE_SIZE" "32M" }}

long_query_time                         = {{ getenv "MYSQL_LONG_QUERY_TIME" "2" }}
slow-query-log                          = {{ getenv "MYSQL_SLOW_QUERY_LOG" "OFF" }}
general-log                             = {{ getenv "MYSQL_GENERAL_LOG" "0" }}
