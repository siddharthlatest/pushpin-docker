#!/bin/sh

sed -i -e "s/localhost:80/$APP,over_http/" /pushpin/routes

exec /pushpin/pushpin