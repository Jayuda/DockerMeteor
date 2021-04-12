#!/usr/bin/env bash

set -e

if [ -d /bundle ]; then
  echo "MASUK ZONE 1"
  cd /bundle
  tar xzf *.tar.gz
  cd /bundle/bundle/programs/server/
  npm install --unsafe-perm
  npm uninstall node-pre-gyp --save
  npm install @mapbox/node-pre-gyp --save
  cd /bundle/bundle/
elif [[ $BUNDLE_URL ]]; then
  echo "MASUK ZONE 2"
  cd /tmp
  curl -L -o bundle.tar.gz $BUNDLE_URL
  tar xzf bundle.tar.gz
  cd /tmp/bundle/programs/server/
  npm uninstall node-pre-gyp --save
  npm install @mapbox/node-pre-gyp --save  
  npm install --unsafe-perm
  cd /tmp/bundle/
elif [ -d /built_app ]; then
  echo "MASUK ZONE 3"
  cd /built_app
else
  echo "=> You don't have an meteor app to run in this image."
  exit 1
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
