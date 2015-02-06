FROM java:openjdk-7u71-jdk

MAINTAINER CDaaS team

# this image is based on the docker official jenkins image form cloudbees
# and started from a copy of the official dockerfile
# the following additions were made
# 1. within Kadaster it was necessary to enable jenkins to function behind the corporate firewall
# 2. create default volume to put the jobs directory within $JENKINS_HOME on a persistent volume
# 3. copy stdout and stderr from jenkins process to a specific logfile (jenkins.log)
# 4. put the log file in a specific volume within the $JENKINS_HOME directory (log)
# 5. set the correct timezone for the container
# 6. changed from using an ENTRYPOINT to CMD

# prepare apt-get to work behind a proxy
RUN echo "Acquire::http::Proxy \"http://www-proxy.cs.kadaster.nl:8082\";" > /etc/apt/apt.conf

# default build tools
RUN apt-get update  
RUN apt-get install -y wget --fix-missing 
RUN apt-get install -y git --fix-missing 
RUN apt-get install -y zip --fix-missing 
RUN apt-get install -y curl --fix-missing 
RUN rm -rf /var/lib/apt/lists/*

ENV JENKINS_VERSION 1.586
RUN mkdir /usr/share/jenkins/
RUN useradd -d /home/jenkins -m -s /bin/bash jenkins

COPY init.groovy /tmp/WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy

# perform proxy settings
ENV http_proxy  www-proxy.cs.kadaster.nl:8082
ENV https_proxy www-proxy.cs.kadaster.nl:8082
ENV ftp_proxy   www-proxy.cs.kadaster.nl:8082
ENV no_proxy    127.0.0.1, localhost, .so.kadaster.nl, .cs.kadaster.nl

RUN curl -L http://updates.jenkins-ci.org/download/war/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war \
  && cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy && rm -rf /tmp/WEB-INF

ENV JENKINS_HOME /var/jenkins_home
RUN usermod -m -d "$JENKINS_HOME" jenkins && chown -R jenkins "$JENKINS_HOME"

# perform generic proxy settings for jenkins itself
COPY proxy.xml $JENKINS_HOME/proxy.xml
RUN chown jenkins "$JENKINS_HOME/proxy.xml"

# create generic mountable jobs directory
# this has to be done before the VOLUME instruction
# to be able to set and keep the uid:gid on these directory's
RUN \
  mkdir $JENKINS_HOME/jobs \
  && mkdir $JENKINS_HOME/log \
  && chown -R jenkins "$JENKINS_HOME/jobs" \
  && chown -R jenkins "$JENKINS_HOME/log"

# expose specific external directory's as VOLUME
VOLUME ["/var/jenkins_home/jobs", "/var/jenkins_home/log"]

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

# additional tools for javascript development
# node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update
RUN apt-get install -y nodejs --fix-missing
RUN apt-get install -y npm --fix-missing
RUN rm -rf /var/lib/apt/lists/*
# configure proxy for npm
RUN \
npm config set proxy http://www-proxy.cs.kadaster.nl:8082 \
&& npm config set https-proxy http://www-proxy.cs.kadaster.nl:8082 \
&& npm config set strict-ssl false
# now install bower using npm
RUN npm install -g bower
# symlink node to nodejs because bower depends on the name node
RUN ln -s /usr/bin/nodejs /usr/bin/node


# set default user for container when running and place startup script
USER jenkins
COPY jenkins.sh /usr/local/bin/jenkins.sh

# set correct timezone
ENV TZ Europe/Amsterdam

# removed entrypoint, doesn't work, don't know why
#ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
CMD ["usr/local/bin/jenkins.sh"]
