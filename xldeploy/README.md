#XL-Release dockerimage
De dockerfile maakt een image wat geschikt is om een unattended install uit te voeren, die een filebased repository op een persistent volume aanmaakt. Vervolgens kan een container worden gestart op deze persistent repository en XLRelease getest worden.

## Gebruik van het image

Nadat het image kant klaar is kan het eenvoudig gestart worden:

```
docker run -d --name xl-release-p -P -v /tmp/repository:/repository rick/xl-release-p
```

Het default ```CMD``` van het image is het ```server.sh``` commando van xlrelease.

Om te controleren of XL-Release al gestart is:

```
docker logs xl-release
```

XLRelease exposed binnen de container de standaard poort 5516, met `docker ps` kan gecontroleerd worden welke poort dit is op de dockerhost.

## Initialisatie nieuwe repository
Dit gebeurt door interactief een container te maken die de unattended install uitvoert en de persistent repository aanmaakt. Bij het updaten van het image is dit niet meer nodig (de repository wordt overschreven) de installatie wordt silent en impliciet uitgevoerd tijdens het bouwen van het image

```
docker run -i -t -P -v /tmp/repository:/repository rick/xl-release-p /opt/xebialabs/xl-release/xlrelease-server/bin/server.sh -setup -reinitialize -force -setup-defaults /opt/xebialabs/xl-release/xlrelease-defaults.properties
```

## Bouw van het image:

Om het image te kunnen voorzien van je eigen licentie en te gebruiken installatie defaults moet een image worden gebouwd. In de context directory (waar de Dockerfile staat) moeten de juiste versies staan van de volgende bestanden:

* `xl-release-license.lic`
* `xlrelease-defaults.properties`

Deze beide bestanden worden geinjecteerd door de ```Dockerfile``` in het image.

Bouw van het image:
 
```
docker build --rm -t [REPOSITORY[:TAG]] .
```

Het image heeft een volume ```/repository``` waar je eigen persistent volume aan gekoppeld kan worden met ```docker run -v```

## Nieuwe versie van het image
Als er een nieuwe versie van XL-Release komt dan moet het image opnieuw gebouwd worden en ook XL-Release opnieuw geïnstalleerd, bij het bouwen van de image wordt een herinstallatie gedaan op een interne (docker local) repository. Na het bouwen van de image kan er opnieuw een container worden gestart die gekoppeld wordt aan de bestaande repository van de installatie.

## aanloggen in het image
Omdat het image als `CMD` het server.sh script van XL-Release heeft kan er niet zonder meer een interactieve container worden gestart om in de installatie te kunnen kijken. Dit is wel mogelijk door de `/bin/bash` achter het opstart commando te plaatsen.

```
docker run -i -t [REPOSITORY[:TAG]] /bin/bash
```

## aandachtspunten bij gebruik boot2docker
De persistent volume is een volume in de context van de boot2docker vm en niet binnen het OS waar boot2docker draait. Betekent dat je met `boot2docker ssh` aan moet loggen aan de vm en vervolgens een directory aan moet maken die aan de docker container gekoppeld wordt (bijv. /tmp/repository)

### Image exporteren

```
docker save [REPOSITORY[:tag]] > [tarfile]
```

Technische Documentatie en projecthistorie: [link](projectlog.md)
