## Makefile to make it easy to run development commands

# Default env is specified below. 
# To use a different env, specify before running make commands:
# `ENV=test make up`
ENV := dev

# Build docker images
.docker:
	docker-compose --env-file=.env.$(ENV) build --progress=plain
	touch $@

# Install yarn dependencies
.yarn: .docker
	docker-compose --env-file=.env.$(ENV) run web yarn install
	touch $@

# Create the database
.db: .yarn
	docker-compose --env-file=.env.$(ENV) run web bundle exec rails db:create
	touch $@

# Migrate the database
.migrate: .db
	docker-compose --env-file=.env.$(ENV) run web bundle exec rails db:migrate
	touch $@

# Seed the database
.seed: .migrate
	docker-compose --env-file=.env.$(ENV) run web bundle exec rails db:reset
	touch $@

# Start server
up: .seed
	docker-compose --env-file=.env.$(ENV) up

# Stop server
down:
	docker-compose --env-file=.env.$(ENV) down

# run tests
tests: rspec rubocop

rspec:
	docker-compose --env-file=.env.test run web bundle exec rspec

rubocop:
	docker-compose --env-file=.env.test run web bundle exec rubocop

# opens a REPL-like console with application data loaded
console:
	docker-compose --env-file=.env.$(ENV) run web bundle exec rails c

# Opens unencrypted credentials in Vim
edit_credentials:
	docker-compose --env-file=.env.$(ENV) run web bundle exec /bin/bash -c 'EDITOR=vim rails credentials:edit'

clean:
	rm .seed .migrate .db .yarn .docker
