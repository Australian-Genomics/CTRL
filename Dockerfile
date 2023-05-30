FROM debian:bullseye-20230502

SHELL ["/bin/bash", "-lc"]
ENTRYPOINT ["/bin/bash", "-lc", "exec \"$@\"", "--"]

# Use a directory called /code in which to store
# this application's files. (The directory name
# is arbitrary and could have been anything.)
WORKDIR /code

# Copy all the application's files into the /code
# directory.
COPY . /code

RUN : \
  && apt-get update \
  && apt-get install -y curl gnupg2 apt-transport-https \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y nodejs yarn rbenv git libpq-dev \
  && rm -rf /var/lib/apt/lists/* \
  && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /etc/profile \
  && echo 'eval "$(rbenv init -)"' >> /etc/profile \
  && source /etc/profile \
  && rbenv install 2.5.3 \
  && rbenv global 2.5.3 \
  && gem install bundler -v 2.3.26 \
  && rbenv rehash \
  && bundle config --global silence_root_warning 1 \
  && bundle install

# Set "rails server -b 0.0.0.0" as the command to
# run when this container starts.
CMD ["rails", "server", "-b", "0.0.0.0"]
