#!/bin/sh


if [ -z "$DOCKERCLOUD_CONTAINER_HOSTNAME" ]; then
	target=$UPSTREAM:$UPSTREAM_PORT
else
	target=$UPSTREAM-${DOCKERCLOUD_CONTAINER_HOSTNAME##*-}:$UPSTREAM_PORT
fi
 
exec /usr/bin/pushpin --merge-output --port=7999 --route=\"* ${target},over_http\"
