FROM kadaster/jenkins

MAINTAINER CDaaS team

# this image enhaces the jenkins base image with additional plugins and defualt configuration
# note: the base image already contains git

# change to user root for additional install rights
USER root

# add maven
RUN apt-get update && apt-get install -y maven --fix-missing && rm -rf /var/lib/apt/lists/*
# install some Jenkins plugins
# first install a community script for installing jenkins plugins and resolving dependency's
ADD install_jenkins_plugin.sh /usr/local/bin/install_jenkins_plugin.sh

# install plugins as user jenkins
USER jenkins
RUN ["/usr/local/bin/install_jenkins_plugin.sh", "github", "github-oauth", "cucumber-reports", "delivery-pipeline-plugin", "deployit-plugin"]
# plugins that are not definitive yet, to speed up docker file build proces
RUN ["/usr/local/bin/install_jenkins_plugin.sh", "disk-usage", "nodejs", "m2release"]
# create .ssh dir vor jenkins and add some authentication stuff
RUN mkdir /var/jenkins_home/.ssh
ADD config /var/jenkins_home/.ssh/config

USER root
# configure maven settings
ADD settings.xml /etc/maven/settings.xml
RUN chown jenkins:jenkins /etc/maven/settings.xml
RUN chown -R jenkins:jenkins /usr/share/maven-repo
# set some settings so we don't have to manually
ADD hudson.tasks.Maven.xml /var/jenkins_home/hudson.tasks.Maven.xml
RUN chown jenkins:jenkins /var/jenkins_home/hudson.tasks.Maven.xml
# copy default config.xml with LDAP placeholder LDAPGROUP which has to be set using
# environment variable on docker run command
ADD config.xml /var/jenkins_home/config.xml
RUN chown jenkins:jenkins /var/jenkins_home/config.xml
# insert default jenkins startup script
ADD start-jenkins.sh /usr/local/bin/start-jenkins.sh
# insert default credentials
ADD credentials.xml /var/jenkins_home/credentials.xml
RUN chown jenkins:jenkins /var/jenkins_home/credentials.xml

#Configure git client plugin(s)
ADD hudson.plugins.git.GitSCM.xml /var/jenkins_home/hudson.plugins.git.GitSCM.xml
ADD .gitconfig  /var/jenkins_home/.gitconfig
RUN chown jenkins:jenkins /var/jenkins_home/hudson.plugins.git.GitSCM.xml
RUN chown jenkins:jenkins /var/jenkins_home/.gitconfig

# change user back to jenkins to make sure the container starts with this user
USER jenkins
#Generate ssh key for Jenkins to connect to github with, public key is stored in the jobs directory, this can be used in github
RUN ssh-keygen -t rsa -P "" -f /var/jenkins_home/.ssh/id_rsa

USER root
RUN mkdir /var/jenkins_home/github_key/ && cp /var/jenkins_home/.ssh/id_rsa.pub /var/jenkins_home/github_key/id_rsa.pub && chmod -R 777 /var/jenkins_home/github_key/

# start customized start script, this will set the default
# authorization group and run jenkins process as user jenkins
CMD ["/usr/local/bin/start-jenkins.sh"]
