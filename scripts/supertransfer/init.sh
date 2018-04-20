#!/bin/bash
#source settings.conf
# functions:
# cat_Art() - init msg
# upload_Json() - configure with new jsons
# configure_json() - load jsons into rclone config
# init_DB() - validates gdsa's & init least usage DB

cat_Art(){
cat <<ART
[32m
                         __                    ___
  ___ __ _____  ___ ____/ /________ ____  ___ / _/__ ____ [35m2[32m
 (_-</ // / _ \/ -_) __/ __/ __/ _ \`/ _ \(_-</ _/ -_) __/
/___/\_,_/ .__/\__/_/  \__/_/  \_,_/_//_/___/_/ \__/_/
        /_/    [1;39;2mUnlimited Parallelized Gdrive Uploader
[0m
┌────────────────────────────────────────────────────────┐
│ Version               :   Beta 2.1                     │
│ Author                :   Flicker-Rate                 │
│ Special Thanks To     :   ddurdle                      │
│ —————————————————————————————————————————————————————— │
│ [5;31m           ⚠ Loose Lips Might Sink Ships! ⚠[0m            │
│      Do your part and keep publicity to a minimum.     │
│     Don't talk about this method on public forums.     │
└────────────────────────────────────────────────────────┘

ART
}


upload_Json(){
[[ ! -e $jsonPath ]] && mkdir $jsonPath && log 'Json Path Not Found. Creating.' INFO
[[ ! -e $jsonPath ]] && log 'Json Path Could Not Be Created.' FAIL
[[ ! -e $settings ]] && cp settings.conf $jsonPath && log 'Configuration File Not Found. Creating.' INFO
[[ ! -e $settings ]] && log "Config at $settings Could Not Be Created." FAIL

localIP=$(curl -s icanhazip.com)
[[ -z $localIP ]] && localIP=$(wget -qO- http://ipecho.net/plain ; echo)
trap "kill $jobpid" SIGTERM
cd $jsonPath
python3 /opt/plexguide/scripts/supertransfer/jsonUpload.py &>/dev/null &
jobpid=$!

cat <<MSG

############ CONFIGURATION ################################

1. Go to [32mhttp://${localIP}:8000[0m
2. Upload 9-99 Gsuite service account json keys
          - each key == +750gb max daily upload

Don't have them? Instructions are in that link.
Make sure you allow api access in the security settings
and check "enable domain wide delegation"

Want to upload keys securely? SCP json keys directly into
$jsonPath

###########################################################

MSG
read -rep $'\e[032m          -- Press any key when you are done uploading --\e[0m'
trap "exit 1" SIGTERM
start_spinner "Terminating Web Server."
sleep 0.5
{ kill $jobpid && wait $jobpid; } &>/dev/null
stop_spinner $?

if [[ $(ps -ef | grep "jsonUpload.py" | grep -v grep) ]]; then
  start_spinner "Web Server Failed To Terminate. Attempting again."
	jobpid=$(ps -ef | grep "jsonUpload.py" | grep -v grep | awk '{print $2}')
	sleep 5
  { kill $jobpid && wait $jobpid; } &>/dev/null
  stop_spinner $?
fi

numKeys=$(ls $jsonPath | egrep -c .json$)
if [[ $numKeys > 0 ]];then
   log "Found $numKeys Service Account Keys" INFO
    read -p 'Please Enter your Gsuite email: ' email
    sed -i '/'^$gdsaImpersonate'=/ s/=.*/='$email'/' $settings
    source $settings
    [[ $gdsaImpersonate == $email ]] && log "SA Accounts Configured To Impersonate $gdsaImpersonate" INFO || log "Failed To Update Settings" FAIL
else
   log "No Service Keys Found" FAIL
   return 1
fi
return 0
}


configure_Json(){
rclonePath=$(rclone -h | grep 'Config file. (default' | cut -f2 -d'"')
[[ ! $(ls $jsonPath | egrep .json$) ]] && log "No Service Accounts Json's Found in $jsonPath" FAIL && return 1
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
[[ -n $newGdsaCount ]] && log "$newGdsaCount New Gdrive Service Accounts Added." INFO
return 0
}


init_DB(){
[[ $gdsaImpersonate == 'your@email.com' ]] \
  && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Email Configured. Please edit $settings" \
  && return 1

# get list of avail gdsa accounts
gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
if [[ -n $gdsaList ]]; then
    numGdsa=$(echo $gdsaList | wc -w)
    maxDailyUpload=$(python3 -c "round($numGdsa * 750 / 1000, 3")
    echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tInitializing $numGdsa Service Accounts:\t${maxDailyUpload}TB Max Daily Upload"
    echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tValidating Domain Wide Impersonation:\t$gdsaImpersonate"
else
    echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Valid SA accounts found! Is Rclone Configured With GDSA## remotes?"
    return 1
fi

# validate gdsaList, purge broken gdsa's & init db
echo '' > $gdsaDB
for gdsa in $gdsaList; do
  if [[ $(rclone touch --drive-impersonate $gdsaImpersonate ${gdsa}:/.SAtest ) ]]; then
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
