#!/bin/bash

set -e

FPM_SERVICE="php8.3-fpm"
NGINX_SERVICE=nginx

# start fpm
echo "Starting PHP-FPM..."
service $FPM_SERVICE start
service $FPM_SERVICE status

# start nginx daemon
echo "Starting nginx..."
service $NGINX_SERVICE start
service $NGINX_SERVICE status

# execute this function when a SIGINT/SIGTERM signal is received
function cleanup()
{
    echo "Stopping $NGINX_SERVICE..."
    service $NGINX_SERVICE stop

    echo "Stopping $FPM_SERVICE..."
    service $FPM_SERVICE stop

    exit 0
}

trap cleanup INT TERM

# monitor both services, exit if one of them fails
while true
do
  if [[ "$(service $FPM_SERVICE status)" == *"is not running"* ]]; then
    echo "$FPM_SERVICE failed."
    service $FPM_SERVICE status
    exit 1
  fi

  if [[ "$(service $NGINX_SERVICE status)" == *"is not running"* ]]; then
    echo "$NGINX_SERVICE failed."
    service $NGINX_SERVICE status
    exit 1
  fi

  sleep 5
done
