#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf
source spinner.sh

if [[ $@ =~ [--help|-h] ]
# init
if [[ $@ =~ [--pw=durdle] || -e /opt/appdata/plexguide/.rclone ]]; then
cat_Secret_Art
else
cat_Art
fi

# source settings
[[ ! -e $usersettings ]] && cp usersettings.conf $jsonPath && echo 'Configuration File Not Found. Creating.'
[[ ! -e $usersettings ]] && echo "Config at $usersettings Could Not Be Created."
source $usersettings

# spinny
if [[ -z $@ ]]; then
read -p '             -- Press Any Key To Continue -- '
echo
start_spinner "Initializing."
sleep 3
stop_spinner $?
fi


# configure SA keys, if none found
function configure_SA(){
  if [[ ! $(ls $jsonPath | egrep .json$)  ]]; then
    read -p 'No Service Keys Found. Configure? y/n>' answer
      if [[ $answer =~ [y|Y|yes|Yes] || $answer == "" ]];then
        upload_Json
      else
        exit 1
      fi
  elif [[ $@ =~ "--config" ]]; then
    upload_Json
  fi
}
configure_SA

# configure email, if user didn't do it in the last step
function configure_email(){
  if [[ $gdsaImpersonate == 'your@email.com' ]]; then
      log "No Email Configured in: usersettings.conf" WARN
      read -p 'Please Enter your Gsuite email: ' email
      sed -i '/'^gdsaImpersonate'=/ s/=.*/='$email'/' $usersettings
      source $usersettings
      [[ $gdsaImpersonate == $email ]] && log "SA Accounts Configured To Impersonate $gdsaImpersonate" INFO || log "Failed To Update Settings" FAIL
  fi
}
configure_email

# configure json's for rclone
configure_Json
gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
[[ -z $gdsaList ]] && log "Rclone Configuration Failure." FAIL && exit 1



# validate new keys
function validate_json(){
  for gdsa in $gdsaList; do
    start_spinner "Validating: ${gdsa}"
    if [[ $(rclone touch --drive-impersonate $gdsaImpersonate ${gdsa}:/.test &>/${jsonPath}.SA_error.log) ]]; then
      sleep 1
      stop_spinner 0
    else
      stop_spinner 1
      ((gdsaFail++))
    fi
  done

  # help user troubleshoot
  if [[ -n $gdsaFail ]]; then
    log "$gdsaFail Validation Failure(s). " WARN
    cat_Troubleshoot
  read -p "Continue anyway? y/n>" answer
  [[ ! $answer =~ [y|Y|Yes|yes] || ! $answer == '' ]] && exit 1
  fi

}
validate_json


echo end
