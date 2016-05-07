ARK Workshop Updater
======================

ARK Workshop Updater est un outil en ligne de commande simple à utiliser pour mettre à jour automatiquement vos workshops Steam sur les serveurs de verygames.

Il vous faut impérativement avoir installé "steamCMD", un outil Steam pour Linux en CLI.

Si vous avez déjà installé steamCMD passez cette partie, téléchargez directement le fichier et suivez les instructions.


Télécharger steamCMD
<steamcmd_download.zip>


Se logguez en tant qu'utilisateur steam

```
su - steam

mkdir ~/ark-workshop-updater

cd ~/ark-workshop-updater

Téléchargez le fichier et dezippez le

wget <file_download.zip>

unzip file_download.zip
```


Il vous faudra configurer vos codes d'accès dans le script. Éditez le avec vim ou un autre éditeur Linux.


Puis exécutez le script en ligne de commande

```
steam@server-linux> sh ark-workshop-updater.sh
```

#### Plusieurs options

*--update : met à jour les mods sur le serveur.

*--check-update : vérifie si des workshops sont à mettre à jour.

*--email "votre.email@mail.com"

*--list-workshop : liste les workshops présent sur le serveur

*--install "workshop_id-1,workshop_id-2,workshop_id-3"

*--reinstall : réinstalle tous les workshops du serveur

*--backup : fait une sauvegarde des mods sur le serveur (rétention de 3 backups max)

*--notify : paramètre automatiquement votre gestionnaire des tâches (cron) pour checker les mises à jour toutes les heures.



#### TODO :

* - ToDo list des trucs a faire
