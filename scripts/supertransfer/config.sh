#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf
source spinner.sh

declare -a reqlist=(rclone awk sed egrep grep echo printf find sort)
for app in $reqlist; do
  [[ $(which $app) ]] || echo -e "$app dependency not met/nPlease install $app"
  [[ $(which $app) ]] || exit 1
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
[[ ! -d $jsonPath ]] && mkdir $jsonPath
[[ ! -d $logDir ]] || mkdir $logDir
[[ ! -e $userSettings ]] && cp usersettings_template_dont_edit ${jsonPath}/usersettings.conf
[[ ! -e ${jsonPath}/auto-rename-my-keys.sh ]] && cp auto-rename-my-keys.sh $jsonPath
[[ ! -e $userSettings ]] && echo "Config at $userSettings Could Not Be Created."
source $userSettings

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
      log "No Email Configured in: userSettings.conf" WARN
      read -p 'Please Enter your Gsuite email: ' email
      [[ ! $email =~ .@. ]] && read -p 'Invalid email. Try Again: ' email
      [[ ! $email =~ .@. ]] && read -p 'Invalid email. Try Again: ' email
      [[ ! $email =~ .@. ]] && read -p 'Invalid email. Try Again: ' email
      sed -i '/'^gdsaImpersonate'=/ s/=.*/='$email'/' $userSettings
      source $userSettings
      [[ $gdsaImpersonate == $email ]] && log "SA Accounts Configured To Impersonate $gdsaImpersonate" INFO || log "Failed To Update Settings" FAIL
  fi
}
#configure_email

function configure_teamdrive(){
source $userSettings
  if [[ -z $teamDrive ]]; then
      log "No Teamdrive Configured in: userSettings.conf" WARN
cat <<EOF
NOTE: this method doesn't work with personal gdrives.

a) If you already have data in a personal drive, you can
   easily copy it over to the team drive.
b) If you are using plexdrive, you need to migrate to rclone cache (to support TD)

Additional limitations: 1) Only 250,000 files allowed per teamdrive
                        2) Folders may only be 20 directories deep
########## INSTRUCTIONS ###################################
1) Make a Team Drive in the Gdrive webui.
2) Find the Team Drive ID— \e[032it looks like this:\e[0m
   https://drive.google.com/drive/folders/\e[084g3BHcoUu8IHgWUo5PSA\e[0m
###########################################################
EOF

      read -p 'Please Enter your Team Drive ID: ' teamId
      sed -i '/'^teamDrive'=/ s/=.*/='$teamId'/' $userSettings
      source $userSettings
      [[ $teamId == $teamDrive ]] && log "SA Accounts Configured to use team drives." INFO || log "Failed To Update Settings" FAIL
  fi
}
configure_teamdrive
configure_teamdrive_share


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
    rclone touch ${gdsa}:/.test &>/tmp/.SA_error.log.tmp && s=1
    if [[ $s == 1 ]]; then
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

echo "[DBUG] config script end. run supertransfer_redux.sh to initiate upload."
