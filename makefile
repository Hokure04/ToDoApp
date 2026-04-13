include .env
export

export PROJECT_ROOT=$(shell pwd)

env-up:
	@docker compose up -d todoapp-postgres

env-down:
	@docker compose down todoapp-postgres

env-cleanup:
	@printf "Are you sure you want to cleanup all environment files? Risk of data loss. [y/n]:"; \
	read ans; \
	if [ "$$ans" = "y" ]; then \
	  docker compose down todoapp-postgres; \
	  sudo rm -rf out/pgdata; \
	  echo "Environment files clean success"; \
	else \
  		echo "Environment cleanup cancelled"; \
  	fi

migrate-create:
	@if [ -z "$(seq)" ]; then \
  		echo "Parameter is missing seq. Try: make migrate-create seq=init"; \
  		exit 1;\
  	fi; \
	docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down


env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder

migrate-action:
	@if [ -z "$(action)" ]; then \
      		echo "Parameter is missing action. Try: make migrate-action action=up"; \
      		exit 1;\
      	fi; \
	docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
        -database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
        "$(action)"
