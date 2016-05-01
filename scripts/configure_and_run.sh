#!/bin/sh

if [ -z "$DOCKERCLOUD_CONTAINER_HOSTNAME" ]; then
	sed -i -e "s/localhost:80/$UPSTREAM:$UPSTREAM_PORT,over_http/" /pushpin/routes
else
	sed -i -e "s/localhost:80/$UPSTREAM-${DOCKERCLOUD_CONTAINER_HOSTNAME##*-}:$UPSTREAM_PORT,over_http/" /pushpin/routes
fi

exec /pushpin/pushpin --verbose