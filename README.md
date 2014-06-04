docker
======

repo voor docker trials

==Remove all containers

`$ docker ps -a -q | xargs docker stop | xargs docker rm`

remove all the images

`$ docker images -q | xargs docker rmi`
