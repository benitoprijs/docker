#
# Java Dockerfile
#
# https://github.com/dockerfile/java
#

# Pull base image.
FROM dockerfile/java

# Install Java.
#RUN \
#  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
#  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
#  add-apt-repository -y ppa:webupd8team/java && \
#  apt-get update && \
#  apt-get install -y oracle-java7-installer

# Define mountable directories.
VOLUME ["/data"]

# Define working directory
WORKDIR /data

RUN \
  mkdir -p /opt/xebialabs/xl-release

# Add XLRelease package
ADD https://trials.xebialabs.com/xldownload/download/xlrelease-3.0.4-server.zip /opt/xebialabs/xl-release/
# below is local version of adding resource already downloaded
#ADD ./xlrelease-3.0.4-server.zip /opt/xebialabs/xl-release/

# define settings
ENV XL_RELEASE_SERVER_HOME /opt/xebialabs/xl-release

# Add XLRelease temporary licensfile
ADD ./xl-release-license.lic $XL_RELEASE_SERVER_HOME/conf/

RUN \
  cd /opt/xebialabs/xl-release && \
  unzip xlrelease-3.0.4-server.zip && \
  rm xlrelease-3.0.4-server.zip

# Expose default xl-release port
EXPOSE 5516

# Image is ready for running install, since this is interactive we need to run the container and then continue
# And commit afterwards

# Define default command.
CMD ["bash"]
