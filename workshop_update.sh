#!/bin/bash
# ARK Workshop Updater - ark-workshop-updater.sh
# Author : Thomas Bourcey
# Website : www.tomzone.fr
# Description : ARK Workshop Updater est un outil en ligne de commande simple à utiliser pour mettre à jour automatiquement vos workshops Steam sur les serveurs de verygames.

# DEBUG MODE #
set -x

# VARIABLES #
#############

### FTP CLIENT ID ###
ftpUsername=""
ftpPassword=""
ftpServer="ftp-3.verygames.net"

# Script Variables
scriptName=`realpath $0`
scriptPath=`dirname $scriptName`
steamPath="/home/steam/steamcmd"
steamCMD="$steamPath/steamcmd.sh"
steamWorkshopPath="$steamPath/steamapps/workshop/content/"
appID="346110"
workshop_Z_Unpack="$scriptPath/workshop_z_unpack.py"
workshopFile="$scriptPath/workshop.txt"
workshopInstallFile="$scriptPath/workshop_want_to_install.txt"
workshopIDs=`cat $workshopFile | grep -v '#' | grep -v '.mod' | sed '/^[ \t]*$/d'`
numOfIDs=`echo "$workshopIDs" | wc -l`
counter="0"
currentID=""
tmpFolder="/tmp"
dateLog="$( date +%Y-%m-%d-%H.%M.%S )"
acfFile="$steamPath/steamapps/workshop/appworkshop_346110.acf"



# FUNCIONS #
############

# Rotate function for acf file
acfRotate () {
# Deletes old acf file
if [ -f $acfFile ] ; then
  CNT=5
  let P_CNT=CNT-1
  if [ -f ${acfFile}.5 ] ; then
    rm ${acfFile}.5
  fi

  # Renames acf .1 trough .4
  while [[ $CNT -ne 1 ]] ; do
    if [ -f ${acfFile}.${P_CNT} ] ; then
      mv ${acfFile}.${P_CNT} ${acfFile}.${CNT}
      let CNT=CNT-1
      let P_CNT=P_CNT-1
    fi
  done

  # Copy current acf to .1
  cp $acfFile ${acfFile}.1
fi
}

# Sync installed mods on your ARK Server
function syncData() {
	echo "Sync Data between your ARK Server and our script"
	# Copy your steamapps/workshop/appworkshop_346110.acf file
	acfRotate;
	# Download content from Mods Folder on your ARK Server and write list in workshop.txt
	$( which curl ) -s -l ftp://$ftpServer/games/ark_se/ShooterGame/Content/Mods/ --user $ftpUsername:$ftpPassword > $workshopFile
	# Delete extension .mod and rewrite workshop.txt
	sed -i "/.mod/d" $workshopFile
}

# Download Mods
function downloadMods() {
	# For eatch mod, we run steamcmd +workshop_download_item. Automatically update mod if necessary on our local repo
	while [ $counter -lt $numOfIDs ]; do
		currentID=`echo $workshopIDs | awk '{ print $1 }'`
		workshopIDs=`echo $workshopIDs | cut -d ' ' -f2-`
		echo -e "Downloading item $currentID from Steam... ($(expr $counter + 1)/$numOfIDs)"
		# SteamCMD Download workshop
		$steamCMD +login anonymous +workshop_download_item $appID $currentID validate +quit
		# Now we must extract all archives downloaded
		find $steamWorkshopPath -name "*.z" > $tmpFolder/workshop_$currentID
		while read -r zFile
		do
			extractedFileName=${zFile%.*}
			python $workshop_Z_Unpack $zFile $extractedFileName
			rm -f $zFile
		done < $tmpFolder/workshop_$currentID
		rm -f $tmpFolder/workshop_$currentID
		((counter++))
	done
}

# Update Mods
function updateMods() {
	syncData;
	downloadMods;
	uploadMods;
}

#
function checkUpdate() {

}

# Check if Mods is update
function checkVersionsMods() {
# sed -n '/WorkshopItemDetails/,$p' /home/steam/steamcmd/steamapps/workshop/appworkshop_346110.acf | sed '/[{]/d; /[}]/d; /time/d; /"WorkshopItemDetails"/d'
}

# Manually install Mods
function manuallyInstallMods() {
	echo -n "numOfIDsToInstall" | sed 's/,/\n/g' > $workshopInstallFile
	workshopFile=$workshopInstallFile
	downloadMods;
	uploadMods;
}

# Display usage / help
function usage() {

}

# Upload mods to Verygames server
function uploadMods() {

}

# In a galaxy far far away

echo "========== $scriptName has started. =========="
echo "========== $(date) ========="
echo ""

# read the options
OPT_AWU=`getopt -a -o u,i:,m:,l,r,b,n,c --long update,install:,mail:,list-workshop,reinstall,backup,notify,check-update -n $scriptName -- "$@"`
eval set -- "$OPT_AWU"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -u|--update)
					syncData;
					downloadMods;
				;;
				-i|--install)
					numOfIDsToInstall=$1
					manuallyInstallMods;
				;;
				-m|--mail)
				;;
				-l|--list-workshop)
				;;
				-r|--reinstall)
				;;
				-b|--backup)
				;;
				-n|--notify)
				;;
				-c|--check-update)
				;;
        --)
					shift;
					break
				;;
        *) echo "Erreur de syntaxe. Merci de vous corriger :)" ; usage; exit 1
				;;
    esac
done



#echo "Removing old workshop data and moving new items into place..."
#rm -r ~/steamcmd/steamapps/common/qlds/steamapps/workshop
#mv ~/steamcmd/steamapps/workshop/ ~/steamcmd/steamapps/common/qlds/steamapps/workshop
echo "Done."
exit 0
