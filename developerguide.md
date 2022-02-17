# Developer Guide.

Possible strategies for Multi-Language Support.
----------------------

Multi language support aka [internationalization](https://guides.rubyonrails.org/i18n.html) has already been implemented.

To see the English locale, navigate to `config/locales/en.yml`

To add the Chinese locale for example, simply create another yml file `config/locales/ch.yml` and imitate the structure of `en.yml`.

Eg:

From the English locale (en.yml):

```yaml
en:
  hello_world: Hello World!
```

From the Chinese locale (ch.yml):

```yaml
ch:
  hello_world: 你好世界
```

The Survey form builder doesn't support internationalization. However, this could easily be implmented by creating separate fields for each table that displays text.

For example, if we want to support Chinese questions, then we can add a `question_chinese` and `description_chinese` columns to the Question table and modify the Vue components to show the Chinese columns for the Chinese version and show the english columns for the English version.

Two Factor Authentication integration
----------------------

I recommend using [Devise-Two-Factor](https://github.com/tinfoil/devise-two-factor). Devise-Two-Factor is a minimalist extension to Devise which offers support for two-factor authentication, through the [TOTP](https://en.wikipedia.org/wiki/Time-based_One-Time_Password) scheme. It integrates easily with two-factor applications like [Google Authenticator](https://support.google.com/accounts/answer/1066447?hl=en) and [Authy](https://authy.com/)

add Devise-Two-Factor to your Gemfile with:

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

**After running the generator, verify that `:database_authenticatable` is not being loaded by your model. The generator will try to remove it, but if you have a non-standard Devise setup, this step may fail. Loading both `:database_authenticatable` and `:two_factor_authenticatable` in a model will allow users to bypass two-factor authenticatable due to the way Warden handles cascading strategies.**

Discussion around password security and user validation
----------------------

2fa should be enough for security.

Passwords should atleast be 8 characters long.

Special characters shouldn't be a requirement if the user has 2fa setup during registration (overkill).

Integration of a Content Management System
----------------------

I recommend using. (Refinery)[https://github.com/refinery/refinerycms]. Refinery CMS is one of the best Ruby on Rails content management systems for many years now. Released as open-source in 2009, Refinery uses the ‘Rails way’ wherever possible but also allows the flexibility to design your website in your own way.

To integrate Refinery.

Open up your Gemfile and add the latest version (a later version than the one shown may exist):

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

### Generate support files and migrations, and prepare the database.

Generating Refinery on top of an existing application is marginally more complicated than it was before, but it's still quite simple:

```shell
rails generate refinery:cms --fresh-installation
```

This does a couple of things:

* creates `config/initializers/refinery/` and copies over all the required initializers from Refinery

* copies all Refinery migrations to your apps migration folder and runs these migrations, and adds the seed data to your database

* injects Refinery's mounting line into your `config/routes.rb` file
inserts require refinery/formatting and require refinery/theme lines in your apps application.css file

* After this, you should be all set. Don't forget to revisit the initializers in `config/initializers/refinery/` to customize your experience.

### Mounting to a directory other than root

It is possible to mount Refinery to a subfolder. To do this, simply change the following setting in `config/initializers/refinery/core.rb`.

```ruby
config.mounted_path = "/subfolder"
```

After starting your rails server and navigating to `localhost:3000/subfolder`, you should see a dummy home page.

You can create the initial admin user by visiting `localhost:3000/subfolder/refinery`.


Unit testing and End-to-End testing strategies
----------------------

We use Rspec for our unit tests. [RSpec](https://github.com/rspec/rspec-rails) is a unit test framework for the Ruby programming language. RSpec is different than traditional xUnit frameworks like JUnit because RSpec is a Behavior driven development tool. What this means is that, tests written in RSpec focus on the “behavior” of an application being tested. RSpec does not put emphasis on, how the application works but instead on how it behaves, in other words, what the application actually does.

For our Browser automation tool, Install [Capybara](https://github.com/teamcapybara/capybara). Capybara helps by simulating how a real user would interact with the AGHA app.

To install, add this line to your Gemfile and run bundle install:

```ruby
gem 'capybara'
```

If the application that you are testing is a Rails app, add this line to the `spec_helper.rb` file:

```ruby
require 'capybara/rails'
```
