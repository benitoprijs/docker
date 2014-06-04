#!/bin/sh
alias docker='sudo docker'

# start Xebialabs tools, xlrelease and xldeploy

# xl-deploy
docker run -d -p 4516:4516 --name xl-deploy -v /var/appdata/xebiarepo:/repository rick/xl-deploy

# xl-release
docker run -d -p 5516:5516 --name xl-release -v /var/appdata/xebiarepo:/repository rick/xl-release-p

# show all running containers
docker ps
