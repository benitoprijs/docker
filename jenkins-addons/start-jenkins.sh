#!/bin/bash

set -e

if [ $UID -ne 0 ]; then
	echo 'You have to be root to run this script.' >&2
	exit 1
fi

# modify config and give rights to the LDAP group in environment
# variable LDAPGROUP
if [ "$LDAPGROUP" = "" ]; then
	echo 'LDAPGROUP not set in environment' >&2
	exit 1
fi

cd /
cd $JENKINS_HOME
sed -i "s/{{groupname}}/$LDAPGROUP/g" ./config.xml

su jenkins -c /usr/local/bin/jenkins.sh
