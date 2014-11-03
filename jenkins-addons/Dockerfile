FROM kadaster/jenkins

MAINTAINER CDaaS team

# note: the base image already contains git

# change to user root for additional install rights
USER root

# add maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*
# install some Jenkins plugins
ADD install_jenkins_plugin.sh /usr/local/bin/install_jenkins_plugin.sh

USER jenkins
RUN ["/usr/local/bin/install_jenkins_plugin.sh", "github", "github-oauth", "cucumber-reports", "delivery-pipeline-plugin", "deployit-plugin", "envinject", "git-parameter"]

# create maven repo directory
#RUN ["mkdir", "/var/jenkins_home/maven"]

USER root
# configure maven settings
ADD settings.xml /etc/maven/settings.xml
RUN chown jenkins:jenkins /etc/maven/settings.xml
RUN chown -R jenkins:jenkins /usr/share/maven-repo
# set some settings so we don't have to manually
ADD hudson.tasks.Maven.xml /var/jenkins_home/hudson.tasks.Maven.xml
RUN chown jenkins:jenkins /var/jenkins_home/hudson.tasks.Maven.xml

ENV TZ Europe/Amsterdam

USER jenkins
