#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf

OPS=$@
cat_Art
sleep 1
if [[ $(egrep .json$ upload_Json <<<$(ls $jsonPath)) || $OPS =~ "--config" ]]; then
  read -p 'No Service Keys Found. Configure? y/n>' answer
    if [[ $answer =~ "y|yes|Y|Yes" ]];then
      upload_Json
    else
      echo Exiting.
      exit 1
fi

echo end
