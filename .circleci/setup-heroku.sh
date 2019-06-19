#!/bin/bash
git remote add heroku https://git.heroku.com/agha-canary.git
wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
cat > ~/.netrc << EOF
machine api.heroku.com
  login $HEROKU_EMAIL
  password $HEROKU_TOKEN
machine git.heroku.com
  login $HEROKU_EMAIL
  password $HEROKU_TOKEN
EOF