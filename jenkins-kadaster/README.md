# why building the supported Jenkins image again?
This image 'enhances' the jenkins supported dockerhub image by enabling the jenkins build server to function behing a corporate firewall

## using the image
Allthough this image isn't meant for direct execution but meant for enhancing it towards a complete and configured repeatable installation (see [kadaster/jenkins-addons](../jenkins-addons/README.md)) it is possible to run the image itself for test purposes.

## proxy-enablement
Kadaster restricts direct internet-access through the use of a corporate proxy component (`www-proxy.cs.kadaster.nl:8082`), therefore both the docker build process and the docker containers need to know they are behind a proxy. I hav not yet found good solutions to make this transparent for the dockerfile and the created containers.

Although this Dockerfile cannot be used as-is for building in the dockerhub (because of corporate specific proxy-settings) it is still a good example of the specific proxy settings you need to do to enable internet communication :-). For more information see also the [Dockerfile](Dockerfile).
The following components have been proxy-enabled in the image:

* setting of environmentvariables `http_proxy`, `https_proxy`, `ftp_proxy` and `no_proxy` for tools that respect these settings
* `apt` packagemanager through `apt.conf`
* jenkins itself using [proxy.xml](proxy.xml)
* `npm` using config settings

## exported data volume
The default image exports the jenkins_home directory as a total. Jenkins itself doesn't separate installtime configuration, runtime configuration and runtime state in a clean way. Because I want to be able to deliver a new correctly installed version of the container without removing all runtime state I chose to change the exported volume to just the jobs directory within jenkins_home.
This also introduces challenges with uid management between the container and the docker host (maybe in a future version I will make use of a data container for this, however for now I really want to bind the volume to a host directory).

`VOLUME : /var/jenkins_home/jobs` 

## exported log volume
stdout an stderr of the jenkins process (the initial jvm) is tee'd towards `/var/jenkins_home/log/jenkins.log`, see [jenkins.sh](jenkins.sh).
This is a first attempt to get container logging outside of the container where it is picked up by the default Splunk configuration of the Docker host.

`VOLUME : /var/jenkins_home/log` 

## uid management
To be able to mount the specific volumes within the image on a Docker host you have to make sure that both
mounted host directory's are writeable by the uid that is used for jenkins within the image (uid:1000)

## extending the default toolset node.js builds
The image is extended with the installation of **node.js** and **npm**. Both components are configured for use behind the proxy. **Bower** is installed using npm. This is the base installation for enabling the build of javascript websites.

## set the correct time
The dockerhost is using ntp for time synchronization, however the default docker image doesn't know what the current timezone is and doesn't reuse this information from the docker host. Therefore the environment variable `TZ` is configured.


* added plp-jenkins user for attaching to LDAP
* added plp-jenkins as user for jenkins -> github connection
