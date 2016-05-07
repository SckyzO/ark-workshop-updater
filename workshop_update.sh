#! /bin/bash
# autodownload.sh - quake live dedicated server workshop item download utility.
# created by Thomas Jones on 03/10/15.
# thomas@tomtecsolutions.com

set -x

# TODO
# + Functions install mod without sync
# + All in function
# + getopt --update --install-mod --help --check-version 
#

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
workshopIDs=`cat $workshopFile | grep -v '#' | grep -v '.mod' | sed '/^[ \t]*$/d'`
numOfIDs=`echo "$workshopIDs" | wc -l`
counter="0"
currentID=""
tmpFolder="/tmp"


# FUNCIONS #
############

# Sync installed mods on your ARK Server 
function syncData() {

}

# Download Mods
function downloadMods() {

}

function updateMods(){

}

function checkVersionsMods(){

}


# In a galaxy far far away

echo "========== $scriptName has started. =========="
echo "========== $(date) ========="
echo ""
echo "Sync Data between your ARK Server and our script"
# Download content from Mods Folder on your ARK Server and write list in workshop.txt
$( which curl ) -s -l ftp://$ftpServer/games/ark_se/ShooterGame/Content/Mods/ --user $ftpUsername:$ftpPassword > $workshopFile
# Delete extension .mod and rewrite workshop.txt
sed -i "/.mod/d" $workshopFile

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
		extractedFileName=${zFile%%.*}
		python $workshop_Z_Unpack $zFile $extractedFileName
	done < $tmpFolder/workshop_$currentID
	rm -f $tmpFolder/workshop_$currentID
	((counter++))
done
#echo "Removing old workshop data and moving new items into place..."
#rm -r ~/steamcmd/steamapps/common/qlds/steamapps/workshop
#mv ~/steamcmd/steamapps/workshop/ ~/steamcmd/steamapps/common/qlds/steamapps/workshop
echo "Done."
exit 0
