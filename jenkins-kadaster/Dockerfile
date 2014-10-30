FROM java:openjdk-7u65-jdk

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
VOLUME /var/jenkins_home/jobs

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

USER jenkins

COPY jenkins.sh /usr/local/bin/jenkins.sh

# removed entrypoint, doesn't work, don't know why
#ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
CMD ["usr/local/bin/jenkins.sh"]
