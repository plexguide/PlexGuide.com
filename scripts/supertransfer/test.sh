#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf
source spinner.sh


# init
OPS=$@
cat_Art
read -p '-- Press Any Key To Continue -- '

start_spinner "Initializing..."
# source settings
settings=/opt/appdata/plexguide/supertransfer/settings.conf
[[ ! -e $settings ]] && cp settings.conf $jsonPath && log 'Configuration File Not Found. Creating.' INFO
[[ ! -e $settings ]] && log "Config at $settings Could Not Be Created." FAIL
source $settings
stop_spinner $?

if [[ ! $(ls $jsonPath | egrep .json$)  ]]; then
  read -p 'No Service Keys Found. Configure? y/n>' answer
    if [[ $answer =~ "[y|Y]" ]];then
      upload_Json
    else
      exit 1
    fi
elif [[ $OPS =~ "--config" ]]; then
  upload_Json
fi

# configure json's for rclone
numKeys=$(ls $jsonPath | egrep -c .json$)
start_spinner "Configuring $numKeys SA Keys..."
configure_Json
stop_spinner $?
gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
[[ -z $gdsaList ]] && log "Rclone Configuration Failure. No Valid SA's. Exiting." FAIL && exit 1

# validate new keys
for gdsa in $gdsaList; do
  start_spinner "Validating: $gdsa"
  sleep 0.3
  if [[ $(rclone touch --drive-impersonate $gdsaImpersonate ${gdsa}:/.test) ]]; then
    stop_spinner 0
  else
    stop_spinner 1
    (($gdsaFail++))
  fi
done
[[ -n $gdsaFail ]] \
  && log "$gdsaFail Failure(s). Did you enable Domain Wide Impersonation In your Google Security Settings?" WARN


echo end
