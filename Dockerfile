FROM ruby:3.2.2-bullseye

# Use a directory called /code in which to store
# this application's files. (The directory name
# is arbitrary and could have been anything.)
WORKDIR /code

ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy all the application's files into the /code
# directory.
COPY . /code

RUN : \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y nodejs yarn \
  && rm -rf /var/lib/apt/lists/* \
  && bundle install

# Set "rails server -b 0.0.0.0" as the command to
# run when this container starts.
CMD ["rails", "server", "-b", "0.0.0.0"]
