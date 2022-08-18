# Australian Genomics Health Alliance CTRL Project

The [AGHA(Australian Genomics Health Alliance)](https://www.australiangenomics.org.au/introducing-ctrl-a-new-online-research-consent-and-engagement-platform/) Dynamic Consent project is building a web based platform that will manage consent for genomic testing, and allow participants to manage their preferences around how and where their test results are received and shared.

## Table of Contents

- [Installation](#installation)
  - [Getting Started - via Docker (recommended)](#gettingstarteddocker)
  - [Getting Started - Standard](#gettingstartedstandard)
  - [Creating an Admin account](#creatingadminaccount)
- [Guides](#guides)
  - [Strategies for Multi-Language Support](#strategiesfori18n)
  - [Two Factor Authentication integration](#2faintegration )
  - [Password security and user validation](#passwordsecurityanduservalidation)
  - [Integration of a Content Management System](#integrationofcms)
  - [Resetting your environment](#resetenv)
- [Testing](#testing)
  - [Known Issues](#testingknownissues)
- [Deployment](#deployment)
  - [Installing Heroku](#installingheroku)
  - [Deploying to Heroku](#deployingtoheroku)

## <a id="installation"></a> Installation
### <a id="gettingstarteddocker"></a> Getting Started - via Docker (recommended)

There are two ways to get started, via Docker or the standard way. We recommend using Docker to minimise operating system installation issues. To install via Docker, first make sure that [Docker](https://www.docker.com/) is installed on your machine, then follow these steps.

##### From the project root, build the containers:

```shell
docker-compose build
```

#### Decode or create `config/credentials.yml`

If you have been given the `master.key` file, move it to `config/master.key`.
This decodes the `config/credentials.yml.enc` file which should already be
present in this repo. Otherwise, you can create your own `config/master.key` and
`config/credentials.yml.env` files by deleting `config/credentials.yml.enc` then
running:

```shell
docker-compose --env-file=.env.dev run web bundle exec /bin/bash -c 'apt install nano -y && EDITOR=nano rails credentials:edit'
```

In the editor which appears, append the following:

```yml
development:
  mailer:
    email: "adminuser@email.com"
    password: "tester123"
```

Then save the editor and exit.

When deploying a production instance, you will also want to include a
`production:` section in the above yaml file, following the same format as the
`development:` section.

#### Install yarn dependencies

```shell
docker-compose --env-file=.env.dev run web yarn install
```

#### Create the database

```shell
docker-compose --env-file=.env.dev run web bundle exec rails db:create
```

#### Migrate the database

```shell
docker-compose --env-file=.env.dev run web bundle exec rails db:migrate
```

#### Seed the database

```shell
docker-compose --env-file=.env.dev run web bundle exec rails db:seed
```

After seeding, an Admin user is created with the following credentials:

```
email: adminuser@email.com
password: tester123
```

As well as a normal User with the following credentials:

```
email: testuser@email.com
password: tester123
```

#### Start the server!

```
docker-compose --env-file=.env.dev up
```

To access the homepage and login, go to `localhost:3000`.
To access the Active Admin interface and the survey builder, go to `localhost:3000/admin`.

If you want to try and register a new user, you can append with the following Study ID: A1543457

### <a id="gettingstartedstandard"></a> Getting Started - Standard

##### Make sure you have Ruby 2.5.3 by doing `ruby -v` from your console.

##### It is recommended to have Node v14.16.1 (you can check the node version by doing `node -v` from your console). Also do a `yarn -v`  to check if you have yarn installed. If it isn't installed then do `npm install --global yarn`.

##### Install gems via bundler

```shell
bundle install
```

##### Create and build the database.

```shell
rails db:create
rails db:migrate
```

##### Install yarn dependencies

```shell
yarn install
```

##### Seed the database

```shell
rails db:seed
```

##### Start the server! `rails s`


### <a id="creatingadminaccount"></a> Creating an Admin account

To access the Active Admin interface and the survey builder, create an admin account by opening up the server console:

```shell
rails c
```

and create an `AdminUser`

```shell
AdminUser.create(email: 'youremail@gmail.com', password: 'yourpassword')
```

then you can access the admin interface by going to `localhost:3000/admin` and typing in your credentials. Make sure to checkout the Documentation page from the navigation bar.

## <a id="guides"></a> Guides

### <a id="strategiesfori18n"></a> Strategies for Multi-Language Support
Multi-language support (aka [internationalization](https://guides.rubyonrails.org/i18n.html)) has been implemented within the project.

To see the English locale, navigate to `config/locales/en.yml`

To add the Chinese locale for example, create another yml file `config/locales/ch.yml` and imitate the structure of `en.yml`.

For example,

For the `hello_world` line in the English locale (`en.yml`):

```yaml
en:
  hello_world: Hello World!
```

Should correspond to an equivalent translated line in the the Chinese locale (`ch.yml`):

```yaml
ch:
  hello_world: 你好世界
```

The Survey form builder does not currently support internationalization. However, this could be implmented by creating separate fields for each table that displays text.

For example, if we want to support Chinese questions, then we can add `question_chinese` and `description_chinese` columns to the `Question` table and modify the Vue components to show the Chinese columns for the Chinese version and show the english columns for the English version.

### <a id="2faintegration"></a> Two Factor Authentication integration

We recommend using [Devise-Two-Factor](https://github.com/tinfoil/devise-two-factor). Devise-Two-Factor is a minimalist extension to Devise which offers support for two-factor authentication, through the [TOTP](https://en.wikipedia.org/wiki/Time-based_One-Time_Password) scheme. It integrates easily with two-factor applications like [Google Authenticator](https://support.google.com/accounts/answer/1066447?hl=en) and [Authy](https://authy.com/).

Add Devise-Two-Factor to your Gemfile with:

```ruby
gem 'devise-two-factor'
```

Next, since Devise-Two-Factor encrypts its secrets before storing them in the database, you'll need to generate an encryption key, and store it in an environment variable of your choice. Set the encryption key in the model that uses Devise:

```ruby
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['YOUR_ENCRYPTION_KEY_HERE']

```

Finally, you can automate all of the required setup by simply running:

```ruby
rails generate devise_two_factor user ENVIRONMENT_VARIABLE
```

`ENVIRONMENT_VARIABLE` is the name of the variable you're storing your encryption key in.

Remember to apply the new migration.

```ruby
bundle exec rake db:migrate
```

It also adds the `:two_factor_authenticatable` directive to the user model, and sets up your encryption key. If present, it will remove `:database_authenticatable` from the model, as the two strategies are incompatible. Lastly, the generator will add a Warden config block to your Devise initializer, which enables the strategies required for two-factor authentication.

From the Application Controller:

```ruby
before_action :configure_permitted_parameters, if: :devise_controller?

...

protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
end
```

*After running the generator, verify that `:database_authenticatable` is not being loaded by your model. The generator will try to remove it, but if you have a non-standard Devise setup, this step may fail. Loading both `:database_authenticatable` and `:two_factor_authenticatable` in a model will allow users to bypass two-factor authenticatable due to the way Warden handles cascading strategies.*

### <a id="passwordsecurityanduservalidation"></a> Password security and user validation

2FA should be sufficient for securing user sessions, but passwords should at least be 8 characters long. Special characters should not be a requirement if the user has 2FA setup during registration.

### <a id="integrationofcms"></a> Integration of a Content Management System

We recommend using [Refinery](https://github.com/refinery/refinerycms). Refinery CMS is in our view one of the best Ruby on Rails content management systems for many years now. Released as open-source in 2009, Refinery uses the ‘Rails way’ wherever possible but also allows the flexibility to design your website in your own way.

To integrate Refinery.

Open up your Gemfile and add the latest version (a later version than the one shown below may exist):

```ruby
gem 'refinerycms', '~> 3.0.0'
```

Refinery doesn't ship with authentication by default, but you will need to add it unless you want every visitor to be automatically logged in.

If you want to use the default authentication system:

```ruby
gem 'refinerycms-authentication-devise', '~> 1.0'
```

Now, to install the gems, run:

```shell
bundle install
```

#### Generating support files and migrations, and preparing the database.

Generating Refinery on top of an existing application is marginally more complicated than it was before, but it's still relatively straightforward:

```shell
rails generate refinery:cms --fresh-installation
```

This command does a few things:

* It creates `config/initializers/refinery/` and copies over all the required initializers from Refinery

* It copies all Refinery migrations to your apps migration folder and runs these migrations, and adds the seed data to your database

* It injects Refinery's mounting line into your `config/routes.rb` file

* It inserts `require refinery/formatting` and `require refinery/theme` lines in your apps application.css file

* After this, you should be all set. Don't forget to revisit the initializers in `config/initializers/refinery/` to customize your experience.

#### Mounting to a directory other than root

It is possible to mount Refinery to a subfolder. To do this, simply change the following setting in `config/initializers/refinery/core.rb`.

```ruby
config.mounted_path = "/subfolder"
```

After starting your rails server and navigating to `localhost:3000/subfolder`, you should see a dummy home page.

You can create the initial admin user by visiting `localhost:3000/subfolder/refinery`.

### <a id="resetenv"></a> Resetting your environment

```bash
# Stop all running containers mentioned in the docker-compose.yml file. Note
# that if services were removed from the docker-compose.yml file between running
# `docker-compose up` and `docker-compose down`, those services will not be
# stopped.
docker-compose down

# Remove all unused containers, networks, images (both dangling and
# unreferenced), and volumes.
docker system prune --all --volumes

# Remove, for example, `node_modules/`, `public/packs/`, `tmp/cache/`.
git reset -xdf
```

## <a id="testing"></a> Testing

We use [Capybara](https://github.com/teamcapybara/capybara) and [Rspec](https://rspec.info/) for our unit tests.

Before running the tests, you might want to run some or all of the commands
in the [resetting your environment](#resetenv) section. (If in doubt, run them all!)

Make sure you also follow the
[Getting Started - via Docker (recommended)](#gettingstarteddocker) section.
However, note that any step containing `--env-file=.env.dev`, should have it
replaced by `--env-file=.env.test`.

With that done, you can run the `cucumber` tests in docker using the following
command:

```shell
docker-compose --env-file=.env.test run web bundle exec rake cucumber
```

Similarly, to run the `rspec` tests:

```shell
docker-compose --env-file=.env.test run web bundle exec rspec
```

### <a id="testingknownissues"></a> Known Issues
*For MacOS Catalina and Big Sur*

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

[Source](https://stackoverflow.com/questions/27875073/an-error-occurred-while-installing-libv8-3-16-14-7-and-bundler-cannot-continu)


## <a id="deployment"></a> Deployment

### <a id="installingheroku"></a> Installing Heroku
Make sure you have installed the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

Login with your Heroku credentials using `heroku login`.

Add the Heroku git remote using `heroku git:remote -a agha`.

### <a id="deployingtoheroku"></a> Deploying to Heroku
```shell
git add .
git commit -m [Your message](https://github.com/erlang/otp/wiki/writing-good-commit-messages)
git push heroku master
```
