#!/bin/sh

set -ex

# nginx.conf doesn't support environment variables,
# so we substitute at run time

/bin/sed \
  -e "s/<API_PORT>/${API_PORT}/g" \
  -e "s/<ADMIN_PORT>/${ADMIN_PORT}/g" \
  -e "s|<API_ENDPOINT>|${API_ENDPOINT}|g" \
  -e "s|<ADMIN_ENDPOINT>|${ADMIN_ENDPOINT}|g" \
  -e "s:<PROXY_TIMEOUT>:${PROXY_TIMEOUT}:g" \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# run in foreground as pid 1
exec /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
