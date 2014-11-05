#!/bin/bash

set -e

if [ $UID -ne 0 ]; then
	echo 'You have to be root to run this script.' >&2
	exit 1
fi

echo Starting xvfb on DISPLAY $DISPLAY
/usr/bin/Xvfb $DISPLAY -screen 0 1366x768x24 -ac&

su jenkins -c /usr/local/bin/jenkins.sh
