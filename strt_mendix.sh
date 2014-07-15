#!/bin/sh
alias docker='sudo docker'

# postgres container with persistent datastore
mkdir -p /var/appdata/mendixdb
docker run -d --name="postgresql" \
             -p 5432:5432 \
             -v /var/appdata/mendixdb:/data \
             -e USER="super" \
             -e DB="mendixdb" \
             -e PASS="welkom2014" \
             paintedfox/postgresql

# start mendix runtime and bind to postgres database
docker run -d -p 5000:5000 mendix/mendix
