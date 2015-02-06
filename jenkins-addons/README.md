# Jenkins Addons image
Dit image bevat de toevoegingen voor Kadaster JaaS (Jenkins as a Service) tov het basisimage [kadaster/jenkins-kadaster](../jenkins-kadaster/README.md), dit basisimage is al geschikt gemaakt voor werking achter de Kadaster www-proxy. De volgende standaard toevoegingen worden gedaan in de [Dockerfile](Dockerfile):

* maven package en maven configuratie
	* de maven repo wordt intern in de container geplaatst (bewust) en is dus weer leeg als er een nieuwe container wordt gestart
* jenkins plugins unattended install script met dependencies [install_jenkins_plugin.sh](install_jenkins_plugin.sh)
* default jenkins plugins
	* github, github-oauth
	* cucumber-reports
	* delivery-pipeline-plugin
	* deployit-plugin
	* disk-usage
	* nodejs
* ldap configuratie en koppeling aan ldapgroup
	* environment variabele LDAP_GROUP bepaalt welke AD groep volledige rechten krijgt op een instantie, wordt uitgevoerd tijdens initiele start van de container
	* alle anonieme en geauthenticeerde users krijgen standaard leesrechten
	* zie [config.xml](config.xml)
* toevoegen default credentials voor plp-jenkins user op de lokale github installatie
* tijdens de build zal er een SSH sleutelpaar gegenereerd worden. Middels het volgende docker exec commando kan je het publieke deel opvragen om deze vervolgens aan je Github Enterprise user te koppelen welke de integratie met Jenkins moet gaan verzorgen:
```
docker exec -t -i <CONTAINER> cat /var/jenkins_home/.ssh/id_rsa.pub]
```
Note: Let er op dat als je een nieuwe build start dat de permissies op de "config" file op maximaal "750" staan ander zal je  tijdens een maven release tegen een SSH demon foutmelding aan gaan lopen dat de permissies op de configuratie niet goed staan.

# Handmatig bouwen en runnen (voorbeeld):
##Stap1:
```
cd jenkins-kadaster

sudo docker build –rm=true -t kadaster/jenkins .
 ```
##Stap2
```
cd jenkins-addons

sudo docker build –rm=true -t kadaster/addons .
 ```
##Starten:
```
sudo docker run -d -p 8084:8080 --name jenkins-pdok -e "LDAPGROUP=pdok-ont-dep" -v /var/appdata/jenkins-jobs:/var/jenkins_home/jobs -v /var/log/jenkins:/var/jenkins_home/log kadaster/jenkins
``` 
## Gebruik met fig
Er is een [fig.yml](fig.yml) configuratie gemaakt om een instantie te starten, hierin wordt een specifieke instantie gestart op poort 8083 voor de AD groep `jap-ont-dep` (de deployers groep voor customer jap in de ont omgeving), daarnaast wordt het jobs volume gemount op een host directory en wordt de jenkins log directory gemount naar /var/log/jenkins directory op de host. Werkwijze hiervoor is beschreven in het basisimage [kadaster/jenkins-kadaster](../jenkins-kadaster/README.md)
Starten van de container gaat met de instructie:

```
fig up -d
```

Door het [fig.yml](fig.yml) uit te breiden met extra containers kunnen meer instanties gestart worden.

## start met shellscript
het shellscript [str_container.sh](strt_container.sh) bevat de commandline voor de start van dezelfde instantie als met de fig configuratie. Dit is voor situaties dat fig nog niet beschibaar is.


