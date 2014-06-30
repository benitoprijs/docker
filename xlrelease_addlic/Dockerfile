#
# XL-Release Dockerfile
#
# https://github.com/rickpeters/docker/xlrelease
#
# version 0.5 layered image add license file to base xl-release-p image
#

# Pull base image, this already contains the java prerequisite.
FROM rick/xl-release-p

MAINTAINER Rick Peters rick.peters@kadaster.nl

# Add XLRelease temporary licensefile
# not directly in destination since this is a symbolic link
ADD ./xl-release-license.lic /opt/xebialabs/xl-release/

# Put license in correct location
RUN \
  mv /opt/xebialabs/xl-release/xl-release-license.lic /opt/xebialabs/xl-release/xlrelease-server/conf/

# Image is ready for running xlrelease
# it is important to mount the parent of the repo directory on
# the /repository volume
