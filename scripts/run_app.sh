#!/usr/bin/env bash

set -e

if [ -d /bundle ]; then
  echo "MASUK ZONE 1"
  cd /bundle
  tar xzf *.tar.gz
  sudo chmod 777 -R /bundle/bundle/programs/server/
  cd /bundle/bundle/programs/server/
  npm uninstall node-pre-gyp --save
  npm install @mapbox/node-pre-gyp --save
  npm install bcrypt@5.0.1 --save
  echo "Install npm Zone 1"
  npm install --unsafe-perm
  cd /bundle/bundle/
fi

if [[ $REBUILD_NPM_MODULES ]]; then
  echo "MASUK ZONE 4"
  if [ -f /opt/meteord/rebuild_npm_modules.sh ]; then
    echo "MASUK ZONE 5"
    cd programs/server
    npm uninstall node-pre-gyp --save
    npm install @mapbox/node-pre-gyp --save
    bash /opt/meteord/rebuild_npm_modules.sh
    cd ../../
  else
    echo "Build for binary bulding."
    exit 1
  fi
fi

# Set a delay to wait to start meteor container
if [[ $DELAY ]]; then
  echo "Delaying startup for $DELAY seconds"
  sleep $DELAY
fi

# Honour already existing PORT setup
export PORT=${PORT:-80}

echo "=> Starting meteor app on port:$PORT"
exec node ${METEORD_NODE_OPTIONS} main.js
