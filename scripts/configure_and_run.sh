#!/bin/sh


if [ -z "$DOCKERCLOUD_CONTAINER_HOSTNAME" ]; then
	target=$UPSTREAM:$UPSTREAM_PORT
else
	target=$UPSTREAM-${DOCKERCLOUD_CONTAINER_HOSTNAME##*-}:$UPSTREAM_PORT
fi

echo "* ${target},over_http" > /etc/pushpin/routes
exec /usr/bin/pushpin --merge-output --port=7999
