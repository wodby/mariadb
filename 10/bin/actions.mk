check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Required parameter is missing: $1$(if $2, ($2))))

command = mariadb-admin -uroot -p${root_password} -h${host} status &> /dev/null
user ?= $(MYSQL_USER)
password ?= $(MYSQL_PASSWORD)
db ?= $(MYSQL_DATABASE)
root_password ?= $(MYSQL_ROOT_PASSWORD)
host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
ignore ?= ""
charset ?= utf8
collation ?= utf8_general_ci

default: query

import:
	$(call check_defined, source)
	import $(user) $(root_password) $(host) $(db) $(source)
.PHONY: import

backup:
	$(call check_defined, filepath)
	backup $(root_password) $(host) $(db) $(filepath) $(ignore)
.PHONY: backup

query:
	$(call check_defined, query)
	mariadb -u$(user) -p$(password) -h$(host) -e "$(query)" $(db)
.PHONY: query

query-silent:
	$(call check_defined, query)
	@mariadb --silent -u$(user) -p$(password) -h$(host) -e "$(query)" $(db)
.PHONY: query-silent

create-db:
	$(call check_defined, name)
	$(eval override charset := $(shell echo "${charset}" | tr -d \'\"))
	$(eval override collation := $(shell echo "${collation}" | tr -d \'\"))
	$(eval override name := $(shell echo "${name}" | tr -d \'\"))
	mariadb -uroot -p$(root_password) -h$(host) -e "CREATE DATABASE IF NOT EXISTS \`$(name)\` CHARACTER SET '$(charset)' COLLATE '$(collation)';"
.PHONY: create-db

drop-db:
	$(call check_defined, name)
	$(eval override name := $(shell echo "${name}" | tr -d \'\"))
	mariadb -uroot -p$(root_password) -h$(host) -e "DROP DATABASE IF EXISTS \`$(name)\`;"
.PHONY: drop-db

create-user:
	$(call check_defined, username, password)
	$(eval override password := $(shell echo "${password}" | tr -d \'\"))
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	mariadb -uroot -p$(root_password) -h$(host) -e "CREATE USER IF NOT EXISTS \`$(username)\`@\`%\` IDENTIFIED BY '$(password)';"
.PHONY: create-user

drop-user:
	$(call check_defined, username)
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	mariadb -uroot -p$(root_password) -h$(host) -e "DROP USER IF EXISTS \`$(username)\`@\`%\`;"
.PHONY: drop-user

grant-user-db:
	$(call check_defined, username, db)
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	$(eval override db := $(shell echo "${db}" | tr -d \'\"))
	mariadb -uroot -p$(root_password) -h$(host) -e "GRANT ALL ON \`$(db)\`.* TO \`$(username)\`@\`%\`;"
.PHONY: grant-user-db

revoke-user-db:
	$(call check_defined, username, db)
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	$(eval override db := $(shell echo "${db}" | tr -d \'\"))
	mariadb -uroot -p$(root_password) -h$(host) -e "REVOKE ALL ON \`$(db)\`.* FROM \`$(username)\`@\`%\`;"
.PHONY: revoke-user-db

query-root:
	$(call check_defined, query)
	mariadb -p$(root_password) -h$(host) -e "$(query)" $(db)
.PHONY: query-root 

mysql-upgrade:
	mariadb-upgrade --upgrade-system-tables --verbose -uroot -p$(root_password) -h$(host)
.PHONY: mysql-upgrade

mysql-check:
	mariadb-check --verbose -uroot -p$(root_password) -h$(host) $(db)
.PHONY: mysql-check

mariadb-upgrade:
	mariadb-upgrade --upgrade-system-tables --verbose -uroot -p$(root_password) -h$(host)
.PHONY: mariadb-upgrade

mariadb-check:
	mariadb-check --verbose -uroot -p$(root_password) -h$(host) $(db)
.PHONY: mariadb-check

check-ready:
	wait_for "$(command)" "MariaDB" $(host) $(max_try) $(wait_seconds) $(delay_seconds)
.PHONY: check-ready

check-live:
	@echo "OK"
.PHONY: check-live
