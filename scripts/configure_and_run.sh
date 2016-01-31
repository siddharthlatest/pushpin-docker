#!/bin/sh

sed -i -e "s/localhost:80/$UPSTREAM-${TUTUM_CONTAINER_HOSTNAME##*-}:$UPSTREAM_PORT,over_http/" /pushpin/routes

exec /pushpin/pushpin --verbose