H1 why building the supported Jenkins image again?
This image 'enhances' the jenkins supported dockerhub image by enabling the jenkins build
behing a corporate firewall

To be able to mount the specific volumes within the image on a Docker host you have to make sure that both
mounted host directory's are writeable by the uid that is used for jenkins within the image (uid:1000)

* added plp-jenkins user for attaching to LDAP
* added plp-jenkins as user for jenkins -> github connection
