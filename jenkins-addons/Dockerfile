FROM kadaster/jenkins

MAINTAINER CDaaS team

# this image enhaces the jenkins base image with additional plugins and defualt configuration
# note: the base image already contains git

# change to user root for additional install rights
USER root

# add maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*
# install some Jenkins plugins
# first install a community script for installing jenkins plugins and resolving dependency's
ADD install_jenkins_plugin.sh /usr/local/bin/install_jenkins_plugin.sh

# install plugins as user jenkins
USER jenkins
RUN ["/usr/local/bin/install_jenkins_plugin.sh", "github", "github-oauth", "cucumber-reports", "delivery-pipeline-plugin", "deployit-plugin"] 

USER root
# configure maven settings
ADD settings.xml /etc/maven/settings.xml
RUN chown jenkins:jenkins /etc/maven/settings.xml
RUN chown -R jenkins:jenkins /usr/share/maven-repo
# set some settings so we don't have to manually
ADD hudson.tasks.Maven.xml /var/jenkins_home/hudson.tasks.Maven.xml
RUN chown jenkins:jenkins /var/jenkins_home/hudson.tasks.Maven.xml

USER jenkins
