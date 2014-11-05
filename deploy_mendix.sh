#!/bin/sh
alias docker='sudo docker'

is_running(){
  running=0
  container=$(docker ps)
  if [ $(echo "$container" | awk '$11 == "'$1'"' | wc -l) -gt 0 ]
  then
    running=1
  fi
  return $running
}

# postgres container with persistent datastore
mkdir -p /var/appdata/mendixdb

is_running postgresql
if [ $? -eq 0 ]
then
  docker run -d --name="postgresql" \
             -p 5432:5432 \
             -v /var/appdata/mendixdb:/data \
             -e USER="super" \
             -e DB="mendixdb" \
             -e PASS="welkom2014" \
             paintedfox/postgresql
fi

# start mendix runtime and bind to postgres database
is_running mendixrt
if [ $? -eq 0 ]
then
  docker run -d -p 5000:5000 --name mendixrt rick/mendix
  # wait for container to run
  sleep 10
fi

mendixresturl=http://`sudo docker inspect mendixrt | grep IPAddress | awk '{ print $2 }' | tr -d ',"'`:5000
mendixdb=`sudo docker inspect postgresql | grep IPAddress | awk '{ print $2 }' | tr -d ',"'`

curl -XPOST -F model=@Stedelijke\ Herverkaveling_1.0.0.136.mda $mendixresturl/upload/
curl -XPOST $mendixresturl/unpack/
# configure mendix container to use postgres
curl -XPOST -d "DatabaseHost=$mendixdb:5432" \
    -d "DatabaseUserName=super" \
    -d "DatabasePassword=welkom2014" \
    -d "DatabaseName=mendixdb" \
    $mendixresturl/config/
#curl -XPOST $mendixresturl/start/

