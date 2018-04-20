#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf
source spinner.sh

# init
OPS=$@
cat_Art
start_spinner "Initializing..."; sleep 5; stop_spinner $?
if [[ ! $(egrep .json$ <<<$(ls $jsonPath)) || $OPS =~ "--config" ]]; then
  [[ ! $(egrep .json$ <<<$(ls $jsonPath)) ]] && \
  read -p 'No Service Keys Found. Configure? y/n>' answer || upload_Json
    if [[ $answer =~ "y" ]];then
      upload_Json
    else
      echo Exiting.
      exit 1
    fi
fi

# configure json's for rclone
numKeys=$(egrep .json$ <<<$(ls $jsonPath))
start_spinner "Configuring $numKeys SA Keys..."
configure_Json
gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
sleep 1
[[ -z $gdsaList ]] && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tRclone Configuration Failure. No Valid SA's. Exiting." && exit 1
stop_spinner $?

# validate new keys
for gdsa in $gdsaList; do
  start_spinner "Validating: $gdsa"
  sleep 0.3
  rclone touch --drive-impersonate $gdsaImpersonate ${gdsa}:/.test || ((++gdsaFail))
  stop_spinner $?
  fi
sleep 0.5
done
[[ -n $gdsaFail ]] \
  && echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\t$gdsaFail Failure(s). Did you enable Domain Wide Impersonation In your Google Security Settings?"


echo end
