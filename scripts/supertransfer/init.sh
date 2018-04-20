#!/bin/bash
#source settings.conf
# functions:
# cat_Art() - init msg
# upload_Json() - configure with new jsons
# configure_json() - load jsons into rclone config
# init_DB() - validates gdsa's & init least usage DB

cat_Art(){
cat <<ART
[34m
                         __                    ___
  ___ __ _____  ___ ____/ /________ ____  ___ / _/__ ____ [31m2[34m
 (_-</ // / _ \/ -_) __/ __/ __/ _ \`/ _ \(_-</ _/ -_) __/
/___/\_,_/ .__/\__/_/  \__/_/  \_,_/_//_/___/_/ \__/_/
        /_/    [32mUnlimited Parallelized Gdrive Uploader
[0m
┌────────────────────────────────────────────────────────┐
| Version               :   Beta 2.1                     |
| Author                :   Flicker-Rate                 |
| Multi SA Method       :   ddurdle                      |
│ —————————————————————————————————————————————————————— │
| Loose Lips Might Sink Ships!                           |
| (please don't talk about this method on public forums) |
└────────────────────────────────────────────────────────┘
ART
}


upload_Json(){
localIP=$(curl -s icanhazip.com)
[[ -z $localIP ]] && localIP=$(wget -qO- http://ipecho.net/plain ; echo)
cd $jsonPath
python3 /opt/plexguide/scripts/supertransfer/jsonUpload.py
jobpid=$!

cat <<MSG

######### CONFIGURATION ################################

Go to [32mhttp://${localIP}:8000[0m
and upload 1-99 Gsuite service account json keys
(reccomended: 5)

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


configure_Json(){
rclonePath=$(rclone -h | grep 'Config file. (default' | cut -f2 -d'"')
[[ ! -e $jsonPath ]] && mkdir $jsonPath && echo -e '[$(date +%m/%d\ %H:%M)] [WARN]\tJson Path Not Found. Creating.'
[[ ! $(ls $jsonPath | egrep .json$) ]] && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Service Accounts Json's Found in $jsonPath" && exit 1
# add rclone config for new keys if not already existing
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


init_DB(){
[[ $gdsaImpersonate == 'your@email.com' ]] \
  && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Email Configured. Please edit /opt/plexguide/scripts/supertransfer/settings.conf" \
  && exit 1

# get list of avail gdsa accounts
gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
if [[ -n $gdsaList ]]; then
    numGdsa=$(echo $gdsaList | wc -w)
    maxDailyUpload=$(python3 -c "round($numGdsa * 750 / 1000, 3")
    echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tInitializing $numGdsa Service Accounts:\t${maxDailyUpload}TB Max Daily Upload"
    echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tValidating Domain Wide Impersonation:\t$gdsaImpersonate"
else
    echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Valid SA accounts found! Is Rclone Configured With GDSA## remotes?"
    exit 1
fi

# validate gdsaList, purge broken gdsa's & init db
echo '' > $gdsaDB
for gdsa in $gdsaList; do
  if [[ $(rclone --drive-impersonate $gdsaImpersonate ${gdsa}:/ ) ]]; then
    echo "${gdsa}=0" >> $gdsaDB
    echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tGDSA Impersonation Success:\t ${gdsa}.json"
  else
    gdsaList=$(echo $gdsaList | sed 's/'$gdsa'//')
    ((++gdsaFail))
    echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\tGDSA Impersonation Failure:\t ${gdsa}.json"
  fi
sleep 0.5
done

[[ -n $gdsaFail ]] \
  && echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\t$gdsaFail Failure(s). Did you enable Domain Wide Impersonation In your Google Security Settings?"

[[ -e $uploadHistory ]] || touch $uploadHistory
}
