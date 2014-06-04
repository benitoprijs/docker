docker
======

## interesting links
Better way to create docker images
* https://github.com/ianmiell/shutit
Osx docker Solution with osx filesystem mount (vagrant)
* https://github.com/liip/dockerbox

##Remove all containers

`$ docker ps -a -q | xargs docker stop | xargs docker rm`

remove all the images

`$ docker images -q | xargs docker rmi`
