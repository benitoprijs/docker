#
# XL-Release Dockerfile
#
# https://github.com/rickpeters/docker/xlrelease
#
# version 0.5
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

# Define mountable directories.
VOLUME ["/data"]

# Define working directory
WORKDIR /data

# Expose default xl-release port
EXPOSE 5516

# Define default CMD.
# in this way running the container without command will just start XL-Release
CMD ["/opt/xebialabs/xl-release/xlrelease-server/bin/server.sh"]

# Image is ready for running install, since this is interactive we need to run the container and then continue
# And commit afterwards to be able to create the final container
# the committed inage can then be started by default at the exposed port
# no persistency is implemented yet

