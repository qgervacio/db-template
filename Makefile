# Copyright 2020 qgervac.io -  All rights reserved.

.PHONY: help

help:
	@echo "Usage: make target [env=[the-env]] [tag=[the-tag]]"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-11s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# defaults
env ?= dev
tag ?= latest

-include env/$(env)/conf.env

export FLYWAY_URL=jdbc:postgresql://${ENV_FLYWAY_HOST}:${ENV_FLYWAY_PORT}/${ENV_FLYWAY_DATABASE}
export FLYWAY_SCHEMAS=${ENV_FLYWAY_SCHEMAS}
export FLYWAY_USER=${ENV_FLYWAY_USER}
export FLYWAY_PASSWORD=${ENV_FLYWAY_PASSWORD}
export FLYWAY_LOCATIONS=${ENV_FLYWAY_LOCATIONS}
export FLYWAY_DATABASE=${ENV_FLYWAY_DATABASE}
export ENV=$(env)
export TAG=$(tag)
export GPG_RECIP=GPG-RECEIPT-HERE

a: apply
apply: ## (a)  Apply the Flyway version files
	@echo "Applying ${ENV}"
	@flyway info migrate validate info

s: sql
sql: ## (s)  Execute a SQL statement against the running container
	@echo "Excuting SQL for ${ENV}"
	@docker-compose exec postgres \
		psql -d ${FLYWAY_DATABASE} -U ${FLYWAY_USER} -c "$(qry);"

b: build
build: ## (b)  Build the image
	@echo "Building ${ENV}"
	@docker-compose build

u: up
up: ## (u)  Start the database container
	@echo "Starting ${ENV}"
	@docker-compose up -d
	@until docker-compose logs | \
		grep "PostgreSQL init process complete; ready for start up" \
		-C 99999; do echo "${ENV_FLYWAY_DATABASE} is not yet ready..."; done
	@sleep 2 # one more chance

x: down
down: ## (x)  Take down the currently running container
	@docker-compose down

sh: ssh
ssh: ## (sh) Get inside the bash of the currently running container
	@docker-compose exec postgres /bin/bash

l: log
log: ## (l)  Show the logs of the currently running container
	@docker-compose logs -f

c: clean
clean: ## (c)  Delete all untracked files and PG data files'
	@rm -rf .tmp

d: decrypt
decrypt: ## (d)  Decrypt sensitive files
	@echo 'Decrypting ${ENV}. Will fail if you have nothing to decrypt!'
	@for f in env/${ENV}/*.gpg; do gpg -o `echo $$f | sed -e "s/.gpg//g"` --yes -d $$f; done

e: encrypt 
encrypt: ## (e)  Encrypt sensitive files
	@echo 'Encrypting ${ENV}'
	@for f in `find env/${ENV} -maxdepth 1 -type f \! -name \*.gpg`; \
		do gpg --batch --always-trust --armor -r ${GPG_RECIP} -o $$f.gpg --yes -e $$f; done
