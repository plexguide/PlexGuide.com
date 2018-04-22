#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf
source spinner.sh

declare -a reqlist=(rclone awk sed egrep grep echo printf find sort)
for app in $reqlist; do
  [[ $(which app) ]] || echo -e "$app dependency not met/nPlease install $app"
  [[ $(which app) ]] || exit 1
done


#if [[ $@ =~ [--help|-h] ]
# init
if [[ $@ =~ --pw=durdle || -e /opt/appdata/plexguide/.rclone ]]; then
cat_Secret_Art
else
cat_Art
fi

if [[ $@ =~ --purge-rclone ]]; then
  purge_Rclone
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

# configure email, if user didn't do it in the last step
function configure_email(){
  if [[ $gdsaImpersonate == 'your@email.com' ]]; then
      log "No Email Configured in: usersettings.conf" WARN
      read -p 'Please Enter your Gsuite email: ' email
      [[ ! $email =~ .@. ]] && read -p 'Invalid email. Try Again: ' email
      [[ ! $email =~ .@. ]] && read -p 'Invalid email. Try Again: ' email
      [[ ! $email =~ .@. ]] && read -p 'Invalid email. Try Again: ' email
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
  echo '' > /tmp/SA_error.log
  for gdsa in $gdsaList; do
    s=0
    start_spinner "Validating: ${gdsa}"
    rclone touch --drive-impersonate $gdsaImpersonate ${gdsa}:/.test &>/tmp/.SA_error.log.tmp && s=1
    if [[ $s == 1 ]]; then
      sleep 1
      stop_spinner 0
    else
      cat /tmp/.SA_error.log.tmp >> /tmp/SA_error.log
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
