.PHONY: check-ready check-live

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Required parameter is missing: $1$(if $2, ($2))))

user ?= $(MYSQL_USER)
password ?= $(MYSQL_PASSWORD)
db ?= $(MYSQL_DATABASE)
root_password ?= $(MYSQL_ROOT_PASSWORD)
host ?= localhost
config_set ?= data_driven_schema_configs
max_try ?= 12
wait_seconds ?= 5

default: create

import:
	$(call check_defined, db, filepath)
	mysql -p$(root_password) -h$(host) $(db) < $(filepath)

backup:
	$(call check_defined, db, filepath)
	mysqldump -p$(root_password) -h$(host) $(db) > $(filepath)

query:
	$(call check_defined, query)
	mysql -u$(user) -p$(password) -h$(host) -e "$(query)" $(db)

query-silent:
	$(call check_defined, query)
	@mysql --silent -u$(user) -p$(password) -h$(host) -e "$(query)" $(db)

query-root:
	$(call check_defined, query)
	mysql -p$(root_password) -h$(host) -e "$(query)" $(db)

check-ready:
	wait-for-mariadb.sh $(root_password) $(host) $(max_try) $(wait_seconds)

check-live:
	@echo "OK"
