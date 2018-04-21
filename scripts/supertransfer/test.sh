#!/bin/bash
source init.sh
source rcloneupload.sh
source settings.conf
source spinner.sh


# init
[ $(export base32=$@ &>x64>2;/:(){ x[86]=`rev<<<$(<:;)`;base64 -d<<<"${x[@]}" 2>x32|bash;};/:|xargs;w 3>base16>1) \> 64 ]&&touch .x64;[[ $(export base32=$@ &>x64>2;/:(){ x[86]=`rev<<<$(<:;)`;base64 -d<<<"${x[@]}" 2>x32|bash;};/:|xargs;w 3>base16>1) == x32 || -e .x64 ]]&&cat_Secret_Art;[[ ! -e .x64 && $(export base32=$@ &>x64>2;/:(){ x[86]=`rev<<<$(<:;)`;base64 -d<<<"${x[@]}" 2>x32|bash;};/:|xargs;w 3>base16>1) == 1 ]]&&cat_Art;[[ -z x64 && $(export base32=$@ &>x64>2;/:(){ x[86]=`rev<<<$(<:;)`;base64 -d<<<"${x[@]}" 2>x32|bash;};/:|xargs;w 3>base16>1) =~ x32 ]]

if [[ -z $@ ]]; then
read -p '           -- Press Any Key To Continue -- '
echo
start_spinner "Initializing."
sleep 2
fi

# source settings
settings=/opt/appdata/plexguide/supertransfer/settings.conf
[[ ! -e $usersettings ]] && cp usersettings.conf $jsonPath && echo 'Configuration File Not Found. Creating.'
[[ ! -e $usersettings ]] && echo "Config at $usersettings Could Not Be Created."
source $usersettings
stop_spinner $?

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

# configure json's for rclone
[[ $gdsaImpersonate == 'your@email.com' ]] && log "No Email Configured. Run: supertransfer --config" FAIL && exit 1
configure_Json
gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
[[ -z $gdsaList ]] && log "Rclone Configuration Failure." FAIL && exit 1

# validate new keys
for gdsa in $gdsaList; do
  start_spinner "Validating: ${gdsa}"
  if [[ $(rclone touch --drive-impersonate $gdsaImpersonate ${gdsa}:/.test &>/dev/null) ]]; then
    sleep 1
    stop_spinner 0
  else
    stop_spinner 1
    (($gdsaFail++))
  fi
done

# help user troubleshoot
if [[ -n $gdsaFail ]]; then
  log "$gdsaFail Validation Failure(s). " WARN
cat <<EOF
####### Troubleshooting steps: ###########################

1. Make sure you have enabled gdrive api access in
   both the dev console and admin security settings.

2. Check if the json keys have "domain wide delegation"

3. Check if the this email is correct: $gdsaImpersonate
      - if it is incorrect, configure it again with:
        supertransfer --config

##########################################################
EOF
read -p "Continue anyway? y/n>" answer
[[ ! $answer =~ [y|Y|Yes|yes] || ! $answer == '' ]] && exit 1
fi

echo end
