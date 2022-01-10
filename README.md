# Australian Genomics Health Alliance

The [AGHA(Australian Genomics Health Alliance)](https://circleci.com/gh/Curve-Tomorrow/agha/tree/master) Dynamic Consent project is building a web based platform that will manage consent for genomic testing, and allow participants to manage their preferences around how and where their test results are received and shared

Getting Started
----------------------
##### Make sure you have the Ruby 2.5.3 by doing `ruby -v` from your console.

##### Do a `bundle install`.

##### Create and build the database.

```shell
rails db:create
rails db:migrate
```

##### Install yarn dependencies

```shell
yarn install
```

##### Start the server! `rails s`

## For running the tests
`bundle exec rspec spec/**/*.rb`

`bundle exec cucumber feature/**/*.feature`


For MacOS Catalina and Big Sur
----------------------

If you encounter this error while bundling:

```
An error occurred while installing libv8 (3.16.14.19), and Bundler
cannot continue.
Make sure that `gem install libv8 -v '3.16.14.19' --source
'https://rubygems.org/'` succeeds before bundling.
```

Update your brew installation.

```shell
brew install v8@3.15
bundle config build.libv8 --with-system-v8
bundle config build.therubyracer --with-v8-dir=$(brew --prefix v8@3.15)
bundle
```

And it should work. [Source](https://stackoverflow.com/questions/27875073/an-error-occurred-while-installing-libv8-3-16-14-7-and-bundler-cannot-continu)

Heroku
----------------------
Login with your Heroku credentials using `heroku login`.

If you don't have access, ask your teammates to give you one.

Add heroku git remote using `heroku git:remote -a agha-canary`.

You can rename the project using 

`git remote rename heroku heroku-staging`

But don't do it unless you want to get fired.

### Deploying your code to heroku from your terminal
```shell
git add .
git commit -m [Your message](https://github.com/erlang/otp/wiki/writing-good-commit-messages)
git push heroku master
```

But you don't need it, We already did that for you on CircleCI, you might want to check `.circleci/config.yml`file.

You can also make changes to this README.md file

For that, do `git checkout agha#-updating-the-readme`. Do it, Create a PR, add reviewers and if they're good, we are happy to merge it to master.


## Setup for MCRI

### Setup
 1. Unzip app
 1. Create DB 'agha_production' with username/password 'agha_api/agha_api' 
 1. Edit the config/database.yml file to match the settings for the DB including the hostname for production
 1. Install ruby (ruby 2.3.1)
 1. Install bundler `gem install bundler`
 1. Install gems `bundle install`
 1. Run db schema update `bundle exec rake db:migrate RAILS_ENV=production`
 1. Run rails `bundle exec rails s -p PORT`
 1. Let's run the test of the UI
 1. Copy .env-example to .env and ask for relevant tokens
 
### Email and delayed jobs
 1. Set the ENV variable EMAIL_SERVER to MCRI `export EMAIL_SERVER=<EMAIL_SERVER>`
 1. Set the ENV variable for ROLLBAR `export ROLLBAR_ACCESS_TOKEN=<ROLLBAR_ACCESS_TOKEN>`
 1. Set the ENV variable for DAILY_CHANGES_EMAIL `export DAILY_CHANGES_EMAIL=<DAILY_CHANGES_EMAIL>`
 1. Add the recurring delayed job for RedCap and Emailing `bundle exec rake recurring:check_redcap_and_send_emails`
 1. Edit the config/environments/production.rb file for MCRI email settings
 1. Run the worker as a background process `bundle exec rake jobs:work`
 
### Add Rollbar
 1. Set the ENV variable for ROLLBAR `export ROLLBAR_ACCESS_TOKEN=<ROLLBAR_ACCESS_TOKEN>`
 1. Test Rollbar with Curve `bundle exec rake rollbar:test`

### Add daily email to Matilda with consent changes
 1. Add the recurring delayed job for daily consent changes email `bundle exec rake recurring:send_consent_changes_email_to_matilda`
