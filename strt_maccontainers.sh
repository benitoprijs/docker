#!/bin/sh
if [ "`uname`" <> "Darwin"]; then
  alias docker='sudo docker'
fi

# start default containers

if ["`uname`" <> "Darwin"]; then
  # jenkins
  docker run -d -p 8081:8080 --name jenkins aespinosa/jenkins

  # jenkins pipeline demo
  docker run -d -p 8080:8080 --name jenkins_pipeline -v /var/run/docker.sock:/var/run/docker.sock cloudbees/jenkins

fi

# rabbitmq
# kijk met docker logs rabbitmq naar het huidige wachtwoord
docker run -d -p 15672 -p 5672 --name rabbitmq tutum/rabbitmq

# wordpress
docker run -d -p 80 --name wordpress tutum/wordpress

# dockerui
docker run -d -p 9000 --name dockerui -v /var/run/docker.sock:/docker.sock crosbymichael/dockerui -e /docker.sock

# neo4j
docker run -i -t -d --privileged -p 7474 --name neo4j tpires/neo4j

# shellinabox
docker run -d --name shellinabox -p 4200 moul/shellinabox 

# show all running containers
docker ps
