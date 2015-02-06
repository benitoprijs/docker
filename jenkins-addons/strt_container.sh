#!/bin/bash

# start de jenkins-addons container (met de kadaster plugins)
# mount de container jenkins jobs directory aan de persistent jobs directory
# mount de container jenkins log directory aan de host /var/log/jenkins directory (moet rechten hebben
# voor uid 1000 (jenkins in de container)
# plaats jenkins op poort 8083 op de host
#

sudo docker run -d -p 8083:8080 -e LDAPGROUP=jap-ont-dep -v /var/appdata/jenkins_home_rick/jobs:/var/jenkins_home/jobs -v /var/log/jenkins:/var/jenkins_home/log --name jenkins-addons kadaster/jenkins-addons
