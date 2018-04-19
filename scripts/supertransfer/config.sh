#!/bin/bash
source settings.conf

uploadJson(){
  localIP=$(curl -s icanhazip.com)
  cd $jsonPath && python3 /opt/plexguide/scripts/supertransfer/jsonUpload.py
cd /opt/plexguide/supertransfer
python3 /root/jsonUpload.py 1>/dev/null &
jobpid=$!

cat <<MSG
[34m
                       _                     __
 ____  _ _ __  ___ _ _| |_ _ _ __ _ _ _  ___/ _|___ _ _
(_-< || | '_ \/ -_) '_|  _| '_/ _\` | ' \(_-<  _/ -_) '_|
/__/\_,_| .__/\___|_|  \__|_| \__,_|_||_/__/_| \___|_|
        |_|                       Author: Flicker-Rate
[0m

######### CONFIGURATION ################################

Go to [32mhttp://${localIP}:8000[0m
and upload your Gsuite service account json keys

Don't have them? Instructions are in that link.
Make sure you allow api access in the security settings
and check "enable domain wide delegation"

Web Server not working? Place json keys directly into
$jsonPath

########################################################

MSG
read -rep $'Press Any Key When You Are Done Uploading\n'
echo
kill -15 $jobpid
sleep 1
if [[ ! $(ps -ef | grep "jsonUpload.py" | grep -v grep) ]]; then
       	echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tWeb Server Terminated Properly."
else
       	echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tWeb Server Failed To Terminate. Trying Again..."
	pid=$(ps -ef | grep "jsonUpload.py" | grep -v grep | awk '{print $2}')
	kill -15 $pid
	sleep 3
	if [[ ! $(ps -ef | grep "jsonUpload.py" | grep -v grep) ]]; then
       		echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tWeb Server Terminated Properly."
	else
		pid=$(ps -ef | grep "jsonUpload.py" | grep -v grep | awk '{print $2}')
	echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\tWeb Server May Not Have Been Terminated Properly.\nPlease Kill Manually With Htop or Kill -15 $pid in a different terminal window."
	fi
fi
sleep 1
numKeys=$(egrep -c .json$ <<<$(ls $jsonPath))
echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tFound $numKeys Service Account Keys"
}

configureJson(){
[[ ! -e $jsonPath ]] && mkdir $jsonPath && echo -e '[$(date +%m/%d\ %H:%M)] [WARN]\tJson Path Not Found. Creating.'
[[ ! $(ls $jsonPath | egrep .json$) ]] && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Service Accounts Json's Found in $jsonPath"
for json in ${jsonPath}/*.json; do
  if [[ ! $(egrep  '\[GDSA[0-9]+\]' -A7 $rclonePath | grep $json) ]]; then
    oldMaxGdsa=$(egrep  '\[GDSA[0-9]+\]' rclone.conf | sed 's/\[GDSA//g;s/\]//' | sort -g | tail -1)
    newMaxGdsa=$(( ++oldMaxGdsa ))
    cat <<-CFG >> $rclonePath
    [GDSA${newMaxGdsa}]
    type = drive
    client_id =
    client_secret =
    scope = drive
    root_folder_id = $rootFolderId
    service_account_file = $json
    team_drive = $teamDrive
    CFG
    ((++newGdsaCount))
  fi
done
[[ -n $newGdsaCount ]] && echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\t$newGdsaCount New Gdrive Service Accounts Added."
}
