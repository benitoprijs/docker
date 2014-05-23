# Eenvoudige testcontainer die als ping gebruikt kan worden
#
# VERSION       0.5

# use the ubuntu base image provided by dotCloud
FROM ubuntu

MAINTAINER Rick Peters, rick.peters@kadaster.nl

# het entrypoint is het ping commando, zodat
# direct het ip-adres opgegeven kan worden
ENTRYPOINT ["ping"]

