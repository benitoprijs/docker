This image 'enhances' the jenkins supported dockerhub image by enabling the jenkins build
behind a corporate firewall

To be able to mount the specific volumes within the image on a Docker host you have to make sure that both
mounted host directory's are writeable by the uid that is used for jenkins within the image (uid:1000)
