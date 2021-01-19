.PHONY: import backup query query-silent query-root check-ready check-live create-db drop-db create-user drop-user grant-user-db revoke-user-db

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Required parameter is missing: $1$(if $2, ($2))))

command = mysqladmin -uroot -p${root_password} -h${host} status &> /dev/null
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

backup:
	$(call check_defined, filepath)
	backup $(root_password) $(host) $(db) $(filepath) $(ignore)

query:
	$(call check_defined, query)
	mysql -u$(user) -p$(password) -h$(host) -e "$(query)" $(db)

query-silent:
	$(call check_defined, query)
	@mysql --silent -u$(user) -p$(password) -h$(host) -e "$(query)" $(db)

create-db:
	$(call check_defined, name)
	$(eval override charset := $(shell echo "${charset}" | tr -d \'\"))
	$(eval override collation := $(shell echo "${collation}" | tr -d \'\"))
	$(eval override name := $(shell echo "${name}" | tr -d \'\"))
	mysql -uroot -p$(root_password) -h$(host) -e "CREATE DATABASE \`$(name)\` CHARACTER SET '$(charset)' COLLATE '$(collation)';"

drop-db:
	$(call check_defined, name)
	$(eval override name := $(shell echo "${name}" | tr -d \'\"))
	mysql -uroot -p$(root_password) -h$(host) -e "DROP DATABASE IF EXISTS \`$(name)\`;"

create-user:
	$(call check_defined, username, password)
	$(eval override password := $(shell echo "${password}" | tr -d \'\"))
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	mysql -uroot -p$(root_password) -h$(host) -e "CREATE USER \`$(username)\`@\`%\` IDENTIFIED BY '$(password)';"

drop-user:
	$(call check_defined, username)
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	mysql -uroot -p$(root_password) -h$(host) -e "DROP USER IF EXISTS \`$(username)\`@\`%\`;"

grant-user-db:
	$(call check_defined, username, db)
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	$(eval override db := $(shell echo "${db}" | tr -d \'\"))
	mysql -uroot -p$(root_password) -h$(host) -e "GRANT ALL ON \`$(db)\`.* TO \`$(username)\`@\`%\`;"

revoke-user-db:
	$(call check_defined, username, db)
	$(eval override username := $(shell echo "${username}" | tr -d \'\"))
	$(eval override db := $(shell echo "${db}" | tr -d \'\"))
	mysql -uroot -p$(root_password) -h$(host) -e "REVOKE ALL ON \`$(db)\`.* FROM \`$(username)\`@\`%\`;"

query-root:
	$(call check_defined, query)
	mysql -p$(root_password) -h$(host) -e "$(query)" $(db)

mysql-upgrade:
	mysql_upgrade --upgrade-system-tables --verbose -uroot -p$(root_password) -h$(host)

mysql-check:
	mysqlcheck --verbose -uroot -p$(root_password) -h$(host) $(db)

check-ready:
	wait_for "$(command)" "MariaDB" $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
