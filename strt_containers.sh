#!/bin/sh
alias docker='sudo docker'

# start default containers
# jenkins
docker run -d -p 8080:8080 --name jenkins aespinosa/jenkins
# rabbitmq
docker run -d -p 15672:15672 -p 5672:5672 --name rabbitmq tutum/rabbitmq
# wordpress
docker run -d -p 80:80 --name wordpress tutum/wordpress

# show all running containers
docker ps
