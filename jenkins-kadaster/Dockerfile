FROM java:openjdk-7u65-jdk

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

RUN apt-get update && apt-get install -y wget git curl zip && rm -rf /var/lib/apt/lists/*

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

USER jenkins
COPY jenkins.sh /usr/local/bin/jenkins.sh

# set correct timezone
ENV TZ Europe/Amsterdam

# removed entrypoint, doesn't work, don't know why
#ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
CMD ["usr/local/bin/jenkins.sh"]
