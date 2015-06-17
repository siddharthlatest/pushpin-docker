#!/bin/sh

sed -i -e "s/localhost:80/$APP/" /pushpin/routes

exec /pushpin/pushpin