#
# XL-Deploy Dockerfile
#
# https://github.com/rickpeters/docker/xldeploy
#
# version 0.6 XL deploy 4.1 beta 1
# version 0.7 XL deploy 4.5
#

# Pull base image, this already contains the java prerequisite.
FROM dockerfile/java

MAINTAINER Rick Peters rick.peters@kadaster.nl

RUN \
  mkdir -p /opt/xebialabs/xl-deploy

# Add XLDeploy package
# cannot do this through online download, because this needs credentials
# ADD https://trials.xebialabs.com/xldownload/download/xlrelease-3.0.4-server.zip /opt/xebialabs/xl-release/
# below is local version of adding resource already downloaded
ADD ./xl-deploy-4.5.0-server.zip /opt/xebialabs/xl-deploy/

# define settings
ENV XL_DEPLOY_SERVER_HOME /opt/xebialabs/xl-deploy/xldeploy-server

# unzip current version of xl-deploy and create generic symbolic link
# to current version
# clean up install package
RUN \
  cd /opt/xebialabs/xl-deploy && \
  unzip xl-deploy-4.5.0-server.zip && \
  ln -s xl-deploy-4.5.0-server/ xldeploy-server && \
  rm xl-deploy-4.5.0-server.zip
  
# Add XLDeploy licensefile
# not directly in destination since this is a symbolic link
ADD ./deployit-license.lic /opt/xebialabs/xl-deploy/

# Put license in correct location
RUN \
  mv /opt/xebialabs/xl-deploy/deployit-license.lic /opt/xebialabs/xl-deploy/xldeploy-server/conf/

# Add installation defaults
ADD xldeploy-defaults.properties /opt/xebialabs/xl-deploy/

# Start unattended installation
# This will only install xlrelease and not really create the initial repository
# since the volume does not exist yet
# it is however important to make sure that XLDeploy in the image already is installed
RUN \
  cd /opt/xebialabs/xl-deploy/xldeploy-server && \
  ./bin/server.sh -setup -reinitialize -force -setup-defaults ../xldeploy-defaults.properties

# Define mountable directories.
VOLUME ["/data"]
VOLUME ["/repository"]

# Define working directory
WORKDIR /data

# Expose default xl-release port
EXPOSE 4516

# Define default CMD.
# in this way running the container without command will just start XL-Release
CMD ["/opt/xebialabs/xl-deploy/xldeploy-server/bin/server.sh"]

# Image is ready for running xlrelease
# it is important to mount the parent of the repo directory on
# the /repository volume
