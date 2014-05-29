#XL-Release dockerimage
De dockerfile maakt een image wat geschikt is om de interactieve installatie mee uit te voeren.
De licensefile moet in de docker context geplaatst worden en wordt in de image geplaatst

Bouw het image:

`docker build --rm -t [REPOSITORY[:TAG]] .`

	LETOP TODO: installatie met als entrypoint server.sh lukt niet, na de installatie is de container nog niet helemaal klaar en blijft bij de run in de installatie hangen?

Het installeren van XL-release kan vervolgens met

`docker run -i -t [REPOSITORY[:TAG]] /bin/bash`

`cd /opt/xebialabs/xl-release/xlrelease-server/bin`

`./server.sh -setup`

volg de instructies voor installatie

Na installatie kan de container worden verlaten en moet deze gecommit worden naar een nieuw image

`docker commit -m "geinstalleerde XL-release" CONTAINER [REPOSITORY[:TAG]]`

	LETOP TODO: vervelend genoeg verdwijnt door de commit het oorspronkelijke default command?

Met dit geinstalleerde image kan vervolgens XL-release gestart worden:

`docker run -d --name xl-release -P [REPOSITORY[:TAG]] /opt/xebialabs/xl-release/xlrelease-server/bin/server.sh`

De tussentijdse niet geïnstalleerde image kan indien gewenst verwijderd worden.

Om te controleren of XL-Release al gestart is:

`docker logs xl-release`
