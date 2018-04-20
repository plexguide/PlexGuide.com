#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf

OPS=$@
cat_Art
spinner 20 "Initializing..."
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

echo end
