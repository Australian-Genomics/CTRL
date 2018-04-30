# [AGHA](https://circleci.com/gh/Curve-Tomorrow/agha/tree/master)

`The AGHA(Australian Genomics Health Assurance) Dynamic Consent project is building a web based platform that will manage consent for genomic testing, and allow participants to manage their preferences around how and where their test results are received and shared`

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See [Deployment](#deployment) on how to deploy the project on a live system.

### Prerequisites
You can check out, on how to install [rbenv](https://github.com/rbenv/rbenv)

rbenv is our preferred ruby version management software.
For installing the ruby version, just type in your terminal:
 
`rbenv install 2.3.1`

You can check your ruby version by hitting your terminal with 

`ruby -v`
 
It should say something like this

`ruby 2.3.1p112`

Installing rails, just type in your terminal:
`gem install rails`:

This will install the latest rails version for you. 
You can check in your rails version by using this command:
 `rails -v`:

It should say something like this:

`Rails >= 5.2.0.rc1`


### Getting the project in your hands

Make sure you have git installed on your system, if you haven't, just refer this [How to install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Make sure you have the project permissions to clone. To Clone the github repository for AGHA, type in your terminal with

`git clone https://github.com/Curve-Tomorrow/agha.git`

Let's try getting the AGHA server running by doing a couple of things

`cd agha`

`bundle install --path vendor/bundle` => to install the project dependencies in the vendor/bundle folder in the project directory. Add this to your .gitignore file.

If you type in your terminal now with
 `rails -v`
 
You'll get,

`Rails 5.2.0.rc1` => rails version, our AGHA project is based on.
 
"If you get any errors while installing, solve it yourself."
This is funny and quirky, but may offend some people. I believe the usual standard is to write:

"We believe the installation process to run smoothly. But if it doesn't, we encourage you to try out the usual help from google/stackoverflow. If you're so inclined, you may also create an issue here with the `need help` label. Please mention details of your environment along with the report."


Getting into the rails server

`bundle exec rails s`

Your server should be running at localhost:3000

##For running the tests 
`bundle exec rspec spec/**/*.rb`

`bundle exec cucumber feature/**/*.feature`

##HEROKU
Login with your heroku credentials using

`heroku login`

If you don't have access, ask your team mates to give you one.

Add heroku git remote using

`heroku git:remote -a agha-canary`

You can rename the project using 

`git remote rename heroku heroku-staging`

But don't do it unless you want to get fired.

###Deploying your code to heroku from your terminal
```shell
git add .
git commit -m [Your message](https://github.com/erlang/otp/wiki/writing-good-commit-messages)
git push heroku master
```

But you don't need it, We already did that for you on CircleCI, you might want to check `.circleci/config.yml`file.

You can also make changes to this README.md file

For that, do `git checkout agha#-updating-the-readme`. Do it, Create a PR, add reviewers and if they're good, we are happy to merge it to master.