## Makefile to make it easy to run development commands

# Default env is specified below.
# To use a different env, specify before running make commands:
# `make ENV=test up`
ENV := dev
COMPOSE_PROFILES := # This can remain unset for local development. Use `test` for testing, `deploy` for deployment.
ALLOWED_HOSTS := # This can remain unset for local development. It is only required for deployment.
IMAGE_REGISTRY := # This can remain unset for local development. If a registry is provided, it must end with a trailing `/`.
RAILS_MASTER_KEY := # This can remain unset for local development. Rails will default to using the file in `config/master.key`.
CADDYFILE_LOCATION := ./Caddyfile.example

# Build docker images
.docker:
	docker compose --env-file=.env.$(ENV) build
	touch $@

# Install yarn dependencies
.yarn:
	docker compose --env-file=.env.$(ENV) run web yarn install
	touch $@

# Create the database
.db: .yarn
	docker compose --env-file=.env.$(ENV) run web bundle exec rails db:create
	touch $@

# Migrate the database
.migrate: .db
	docker compose --env-file=.env.$(ENV) run web bundle exec rails db:migrate
	touch $@

# Seed the database
.seed: .migrate
	docker compose --env-file=.env.$(ENV) run web bundle exec rails db:reset
	touch $@

# Start server
up: .seed
	COMPOSE_PROFILES=$(COMPOSE_PROFILES) \
	ALLOWED_HOSTS=$(ALLOWED_HOSTS) \
	CADDYFILE_LOCATION=$(CADDYFILE_LOCATION) \
	IMAGE_REGISTRY=$(IMAGE_REGISTRY) \
	RAILS_MASTER_KEY=$(IMAGE_REGISTRY) \
	docker compose --env-file=.env.$(ENV) up

# Stop server
down:
	docker compose --env-file=.env.$(ENV) down

# Remove docker volume
rm-volume: down
	docker volume rm ctrl_db_data

# run tests
tests: rspec rubocop

rspec:
	docker compose --profile=test --env-file=.env.test run web bundle exec rspec

rubocop:
	docker compose --profile=test --env-file=.env.test run web bundle exec rubocop

# opens a REPL-like console with application data loaded
console:
	docker compose --env-file=.env.$(ENV) run web bundle exec rails c

# Opens unencrypted credentials in Vim
edit-credentials:
	docker compose --env-file=.env.$(ENV) run web bundle exec /bin/bash -c 'EDITOR=vim rails credentials:edit'

# Generate new encryption keys and salts
# (if you don't have a copy of `config/master.key`)
generate-keys:
	docker compose --env-file=.env.$(ENV) run web bundle exec rails db:encryption:init

clean:
	rm -rf .seed .migrate .db .yarn .docker node_modules public/packs/* tmp/cache/*
