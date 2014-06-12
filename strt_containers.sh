#!/bin/sh
alias docker='sudo docker'

# start default containers
# jenkins
docker run -d -p 8081:8080 --name jenkins aespinosa/jenkins

# rabbitmq
# kijk met docker logs rabbitmq naar het huidige wachtwoord
docker run -d -p 15672:15672 -p 5672:5672 --name rabbitmq tutum/rabbitmq

# wordpress
docker run -d -p 80:80 --name wordpress tutum/wordpress

# jenkins pipeline demo
docker run -d -p 8080:8080 --name jenkins_pipeline -v /var/run/docker.sock:/var/run/docker.sock cloudbees/jenkins

# dockerui
docker run -d -p 9000:9000 --name dockerui -v /var/run/docker.sock:/docker.sock crosbymichael/dockerui -e /docker.sock

# neo4j
#docker run -i -t -d --privileged -p 7474:7474 -name neo4j tpires/neo4j

# shellinabox
docker run -d --name shellinabox -p 4200:4200 moul/shellinabox 

# gitlab
docker run --name=gitlab -d -v /var/appdata/gitlab/data:/home/git/data -p 10022:22 -p 10080:80 -e "GITLAB_PORT=10080" -e "GITLAB_SSH_PORT=10022" sameersbn/gitlab

# show all running containers
docker ps
