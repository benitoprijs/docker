#
# Mendix runtime behind Kadaster firewall
#
# 
#
# version 0.5 based on mendix/mendix, adds www-proxy settings and kadaster proxy certificate
#

# Pull base image, this already contains mendix runtime
FROM mendix/mendix

MAINTAINER Rick Peters rick.peters@kadaster.nl

# Add kadaster proxy certificate
#ADD ./www-proxy.cs.kadaster.nl.cer /usr/local/share/ca-certificates/www-proxy.cs.kadaster.nl.crt

ADD ./mendix-5.5.0.tar.gz /home/mendix/runtimes

#RUN \
#  cd /home/mendix/runtimes &
#  tar xzvf ./mendix-5.5.0.tar.gz .

# perform proxy settings
ENV http_proxy  www-proxy.cs.kadaster.nl:8082
ENV https_proxy www-proxy.cs.kadaster.nl:8082
ENV ftp_proxy   www-proxy.cs.kadaster.nl:8082

