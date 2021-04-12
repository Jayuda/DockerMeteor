#!/usr/bin/env bash

set -e

if [ -d /bundle ]; then
  echo "MASUK ZONE 1"
  cd /bundle
  tar xzf *.tar.gz
  cd /bundle/bundle/programs/server/
  npm install --unsafe-perm
  cd /bundle/bundle/
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
