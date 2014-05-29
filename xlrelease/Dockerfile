#
# Java Dockerfile
#
# https://github.com/dockerfile/java
#

# Pull base image.
FROM dockerfile/ubuntu

# Install Java.
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer

# Define mountable directories.
VOLUME ["/data"]

# Define working directory
WORKDIR /data

RUN \
  mkdir -p /opt/xebialabs/xl-release

# Add XLRelease package
ADD https://trials.xebialabs.com/xldownload/download/xlrelease-3.0.4-server.zip /opt/xebialabas/xl-release/
#ADD ./xlrelease-3.0.4-server.zip /opt/xebialabs/xl-release/
#ADD ./Dockerfile /opt/xebialabs/xl-release/
#ADD ./test.txt /opt/xebialabs/xl-release/

RUN \
  cd /opt/xebialabs/xl-release && \
  unzip xlrelease-3.0.4-server.zip && \
  rm xl-release-3.0.4-server.zip

# Define default command.
CMD ["bash"]
