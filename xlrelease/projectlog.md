#XL-Release dockerimage
De dockerfile maakt een image wat geschikt is om de interactieve installatie mee uit te voeren.
De licensefile moet in de docker context geplaatst worden en wordt in de image geplaatst

## Gebruik van het image

Nadat het image kant klaar is kan het eenvoudig gestart worden:

`docker run -d --name xl-release -P [REPOSITORY[:TAG]] /opt/xebialabs/xl-release/xlrelease-server/bin/server.sh`

De tussentijdse niet geïnstalleerde image kan indien gewenst verwijderd worden.

Om te controleren of XL-Release al gestart is:

`docker logs xl-release`
## Bouw van het image:

Bouw van het uiteindelijke image kan niet uitsluitend met een dockerfile, dit wordt veroorzaakt doordat de XL-Release installatie een interactief onderdeel kent.
Onderstaande instructie laten zien hoe een correct geïnstalleerd XL-Release image gemaakt kan worden. De eerste stap is het maken van een basis image waarmee de interactieve installatie kan worden uitgevoerd:
 
`docker build --rm -t [REPOSITORY[:TAG]] .`

Het installeren van XL-release kan vervolgens met

```
docker run -i -t [REPOSITORY[:TAG]] /bin/bash

cd /opt/xebialabs/xl-release/xlrelease-server/bin

./server.sh -setup
```

volg de instructies voor installatie

Na installatie kan de container worden verlaten en moet deze gecommit worden naar een nieuw image

`docker commit -m "geinstalleerde XL-release" CONTAINER [REPOSITORY[:TAG]]`

## image met repository persistency
* Een volume /repository toegevoegd
* dit volume gelinkt aan de host /tmp/repository (in de boot2docker vm)

	`docker run -i -t -v /tmp/repository:/repository rick/xl-release-p:0.9 /bin/bash`

* installatie uitgevoerd op deze repository

	`./server.sh -setup`
	* geen simple install
	* geen ssl
	* let op kies poort 5516
	* repository op /repository
	* repository niet initialiseren (dat mislukt, doen we in aparte stap)

Nu is de container klaar om tot image verheven te worden (zie boven)

Deze nieuwe image kan gestart worden als hierboven, maar met de toevoeging van de volume mount.
Let op dat de .lock file in de repository directory weg is.

Starten van het eindimage en opstarten van xl-release gaat met:

`docker run -d --name xl-release-p -P -v /tmp/repository:/repository [REPOSITORY[:TAG]] /opt/xebialabs/xl-release/xlrelease-server/bin/server.sh`

### maken van de initiele repository (niet nodig als deze er al is)
* repository initialiseren

	`./server.sh -setup -reinitialize`	

	LET OP TODO: op dit tussenimage kan ook met een Dockerfile het CMD worden aangepast zodat de image gestart kan worden zonder commando op te geven
	Of de gewijzgide bestanden uit de conf directory extern halen en in de dockerfile met ADD toevoegen
	
	TODO 2: de tijd in de container is verkeerd
	
* unattended install

	`https://support.xebialabs.com/entries/23468241-automatic-setup-of-3-8-4`
	
* let op: grote probleem is dat de repo directory nog niet mag bestaan, het moet dus een subdirectory van het persistent volume zijn :-(

### installatie van een nieuwe instantie met persistent disk
ik weet nog niet waar de persistent data van de vm zit?
de peristent directory moet al bestaan in de scope van de dockerhost

```
docker run -i -t -P -v /tmp/repository:/repository rick/xl-release-p /bin/bash

cd /opt/xebialabs/xl-release/xlrelease-server

./bin/server.sh -setup -reinitialize -force -setup-defaults ../xlrelease-defaults.properties
```
dit moet ook in één keer kunnen met:

```
docker run -i -t -P -v /tmp/repository:/repository rick/xl-release-p /opt/xebialabs/xl-release/xlrelease-server/bin/server.sh -setup -reinitialize -force -setup-defaults /opt/xebialabs/xl-release/xlrelease-defaults.properties
```
### starten van de nieuwe instantie
starten van de server zit in het default cmd

```
docker run -d --name xl-release-p -P -v /tmp/repository:/repository rick/xl-release-p
```

met een ENTRYPOINT kan dit ook, maar dat heeft als nadeel dat ik geen gewone CMD meer kan uitvoeren op de container

-> kan wel met `--entrypoint=""` 

Helemaal externe conf file kan ook als deze beschikbaar is in het persisted volume (dat kun je aanwijzen met de -setup-defaults)
Het huidige image is daarmee prachtig

Image exporteren

```
docker save rick/xl-release-p:latest > xl-release-p-image.tar
```