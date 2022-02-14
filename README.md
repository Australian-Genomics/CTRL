# Australian Genomics Health Alliance

The [AGHA(Australian Genomics Health Alliance)](https://circleci.com/gh/Curve-Tomorrow/agha/tree/master) Dynamic Consent project is building a web based platform that will manage consent for genomic testing, and allow participants to manage their preferences around how and where their test results are received and shared

Getting Started - via Docker
----------------------

There are two ways to get started, via Docker or the standard way. If you want to get started with docker then follow these steps:

##### From the project root, build the containers:

```shell
docker-compose up -d --build
```

#### Install yarn dependencies

```
docker-compose run web yarn install
```

#### Create the database

```
docker-compose run web bundle exec rails db:create
```

#### Migrate the database

```
docker-compose run web bundle exec rails db:migrate
```

#### Seed the database

```
docker-compose run web bundle exec rails db:seed
```

After seeding, an Admin user is created with the following credentials:

email: adminuser@email.com
password: tester123

As well as a normal User with the following credentials:

email: testuser@email.com
password: tester123

#### Start the server

```
docker-compose up
```

To access the homepage and login, go to `localhost:3000`.
To access the Active Admin interface and the survey builder, go to `localhost:3000/admin`.

If you want to try and register a new user, you can append with the following Study ID: A1543457

Getting Started - Standard.
----------------------

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


## Creating an admin account.

To access the Active Admin interface and the survey builder, create an admin account by opening up the server console:

```shell
rails c
```

and create an `AdminUser`

```shell
AdminUser.create(email: 'youremail@gmail.com', password: 'yourpassword')
```

then you can access the admin interface by going to `localhost:3000/admin` and typing in your credentials. Make sure to checkout the Documentation page from the navigation bar.

## For running tests

We use capybara and rspec for our unit tests. Type and enter `rspec` in your console to run the tests.


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

Heroku Installation
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
