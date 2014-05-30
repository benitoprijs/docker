#
# XL-Release Dockerfile
#
# https://github.com/rickpeters/docker/xlrelease
#
# version 0.5
# version 0.6 external volume for repository on /data
#
# Pull base image, this already contains the java prerequisite.
FROM dockerfile/java

MAINTAINER Rick Peters rick.peters@kadaster.nl

RUN \
  mkdir -p /opt/xebialabs/xl-release

# Add XLRelease package
ADD https://trials.xebialabs.com/xldownload/download/xlrelease-3.0.4-server.zip /opt/xebialabs/xl-release/
# below is local version of adding resource already downloaded
#ADD ./xlrelease-3.0.4-server.zip /opt/xebialabs/xl-release/

# define settings
ENV XL_RELEASE_SERVER_HOME /opt/xebialabs/xl-release/xlrelease-server

# unzip current version of xl-release and create generic symbolic link
# to current version
# clean up install package
RUN \
  cd /opt/xebialabs/xl-release && \
  unzip xlrelease-3.0.4-server.zip && \
  ln -s xlrelease-3.0.4-server/ xlrelease-server && \
  rm xlrelease-3.0.4-server.zip
  
# Add XLRelease temporary licensefile
# not directly in destination since this is a symbolic link
ADD ./xl-release-license.lic /opt/xebialabs/xl-release/

# Put license in correct location
RUN \
  mv /opt/xebialabs/xl-release/xl-release-license.lic /opt/xebialabs/xl-release/xlrelease-server/conf/

# Add installation defaults
ADD xlrelease-defaults.properties /opt/xebialabs/xl-release/

# Start unattended installation
# This will only install xlrelease and not create the initial repository
# since the volume does not exist yet
RUN \
  cd /opt/xebialabs/xl-release/xlrelease-server && \
  ./bin/server.sh -setup -reinitialize -force -setup-defaults ../xlrelease-defaults.properties

# Define mountable directories.
VOLUME ["/data"]
VOLUME ["/repository"]

# Define working directory
WORKDIR /data

# Expose default xl-release port
EXPOSE 5516

# Define default CMD.
# in this way running the container without command will just start XL-Release
CMD ["/opt/xebialabs/xl-release/xlrelease-server/bin/server.sh"]

# Image is ready for running xlrelease
# it is important to mount the parent of the repo directory on
# the /repository volume
