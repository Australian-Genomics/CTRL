FROM mcr.microsoft.com/playwright

WORKDIR /code

ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy all the application's files into the /code
# directory.
COPY . /code

RUN npm install
