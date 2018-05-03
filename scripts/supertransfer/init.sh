#!/bin/bash
#source /opt/plexguide/scripts/supertransfer/settings.conf
# functions:
# cat_Art() - init msg
# upload_Json() - configure with new jsons
# configure_json() - load jsons into rclone config
# init_DB() - validates gdsa's & init least usage DB

cat_Secret_Art(){
touch /opt/appdata/plexguide/.rclone
cat <<ART
[32m
                         __                    ___
  ___ __ _____  ___ ____/ /________ ____  ___ / _/__ ____ [35m2[32m
 (_-</ // / _ \/ -_) __/ __/ __/ _ \`/ _ \(_-</ _/ -_) __/
/___/\_,_/ .__/\__/_/  \__/_/  \_,_/_//_/___/_/ \__/_/
        /_/    [1;39;2mLoad Balanced Multi-SA Gdrive Uploader
[0m
┌────────────────────────────────────────────────────────┐
│ Version               :   Beta 2.6 Secret Edition      │
│ Author                :   Flicker-Rate                 │
│ Special Thanks        :   ddurdle, John Doe            │
│ —————————————————————————————————————————————————————— │
│ Bypass the 750GB/day limit on a single Gsuite account. │
│ [5;31m           ⚠ Loose Lips Might Sink Ships! ⚠[0m            │
│      Do your part and keep publicity to a minimum.     │
│     Don't talk about this method on public forums.     │
└────────────────────────────────────────────────────────┘
ART
}

cat_Art(){
cat <<ART
[0m
                         __                    ___
  ___ __ _____  ___ ____/ /________ ____  ___ / _/__ ____
 (_-</ // / _ \/ -_) __/ __/ __/ _ \`/ _ \(_-</ _/ -_) __/
/___/\_,_/ .__/\__/_/  \__/_/  \_,_/_//_/___/_/ \__/_/
        /_/           [1;39;2mRclone Configurator For Plexguide
[0m
┌────────────────────────────────────────────────────────┐
│ Version               :   Beta 2.6                     │
│ Author                :   Flicker-Rate                 │
└────────────────────────────────────────────────────────┘

ART
}
cat_pasta(){
cat <<ART
         _.--.__                                             _.--.
    ./'       `--.__                                   ..-'   ,'
  ,/               |`-.__                            .'     ./
 :,                 :    `--_    __                .'   ,./'_.....
 :                  :   /    `-:' _\.            .'   ./..-'   _.'
 :                  ' ,'       : / \ :         .'    `-'__...-'
 `.               .'  .        : \@/ :       .'       '------.,
    ._....____  ./    :     .. `     :    .-'      _____.----'
              `------------' : |     `..-'        `---.
                         .---'  :    ./      _._-----'
.---------._____________ `-.__/ : /`      ./_-----/':
`---...--.              `-_|    `.`-._______-'  /  / ,-----.__----.
   ,----' ,__.  .          |   /  `\.________./  ====__....._____.'
   `-___--.-' ./. .-._-'----\.                  ./.---..____.--.
         :_.-' '-'            `..            .-'===.__________.'
                               __`--...__.--'            ____
   _______  ______  ___  _____/ /__________ _____  _____/ __/__  _____
  / ___/ / / / __ \/ _ \/ ___/ __/ ___/ __ `/ __ \/ ___/ /_/ _ \/ ___/
 (__  ) /_/ / /_/ /  __/ /  / /_/ /  / /_/ / / / (__  ) __/  __/ /
/____/\__,_/ .___/\___/_/   \__/_/   \__,_/_/ /_/____/_/  \___/_/
          /_/
ART
}

cat_Help(){
cat <<HELP
Usage: supertransfer [OPTION]

##############################
ATTN: Commands not ready yet!
##############################

-s, --status           bring up status menu (not ready)
-l, --logs             show program logs
-r, --restart          restart daemon
    --stop             stop daemon
    --start            start daemon

-c, --config           start configuration wizard
    --config-rclone    interactively configure gdrive service accounts
    --purge-rclone     remove all service accounts and reconfigure
    --set-email=EMAIL  config gdrive account impersonation
    --set-teamdrive=ID config teamdrive with ID (default: no)
    --set-path=PATH    config where files are stored on gdrive: (default: /)

    --pw=PASSWORD      unlocks secret multi-SA mode ;)
                       n00b deterrence:
                       password is reversed base64 of ZWxkcnVkCg==

-v  --validate         validates json account(s)
-V  --version          outputs version
-h, --help             what you're currently looking at

Please report any bugs to @flicker-rate#3637 on discord, or at plexguide.com
HELP
}

cat_Troubleshoot(){
read -p "View Troubleshooting Tips? y/n>" answer
if [[ $answer =~ [y|Y|yes|Yes] ]]; then
cat <<EOF
####### Troubleshooting steps: ###########################

1. Make sure you have enabled gdrive api access in
   both the dev console and admin security settings.

2. Check if the json keys have "domain wide delegation"

3. Check if the this email is correct:
   [1;35m$gdsaImpersonate[0m
      - if it is incorrect, configure it again with:
        supertransfer --config

4. Remove the offending keys and run:
        supertransfer --purge-rclone

5. Check these logs for detailed debugging:
      - /tmp/SA_error.log

##########################################################
EOF
fi

read -p "View Error Log? y/n>" answer
[[ $answer =~ [y|Y|yes|Yes] ]] && less /tmp/SA_error.log
}

upload_Json(){
source /opt/plexguide/scripts/supertransfer/settings.conf
source ${userSettings}
[[ ! -e $jsonPath ]] && mkdir $jsonPath && log 'Json Path Not Found. Creating.' INFO && sleep 0.5
[[ ! -e $jsonPath ]] && log 'Json Path Could Not Be Created.' FAIL && sleep 0.5

localIP=$(curl -s icanhazip.com)
[[ -z $localIP ]] && localIP=$(wget -qO- http://ipecho.net/plain ; echo)
cd $jsonPath
python3 /opt/plexguide/scripts/supertransfer/jsonUpload.py &>/dev/null &
jobpid=$!
trap "kill $jobpid && exit 1" SIGTERM

cat <<MSG

############ CONFIGURATION ################################

1. Go to [32mhttp://${localIP}:8000[0m
2. Follow the instructions to generate the json keys
3. Upload 20-99 Gsuite service account json keys
          - domain wide delegation not needed.

Hint: if you have many keys, it's easier to compress them
      into an archive, upload that, then extract server-side

If port 8000 is closed or you wish to upload keys securely,
Transfer json keys directly into:
$jsonPath

###########################################################

MSG
read -rep $'\e[032m   -- Press any key when you are done uploading --\e[0m'
trap "exit 1" SIGTERM
echo
start_spinner "Terminating Web Server."
sleep 2
{ kill $jobpid && wait $jobpid; } &>/dev/null
stop_spinner $(( ! $? ))

if [[ $(ps -ef | grep "jsonUpload.py" | grep -v grep) ]]; then
  start_spinner "Web Server Still Running. Attempting to kill again."
	jobpid=$(ps -ef | grep "jsonUpload.py" | grep -v grep | awk '{print $2}')
	sleep 5
  { kill $jobpid && wait $jobpid; } &>/dev/null
  stop_spinner $(( ! $? ))
fi

numKeys=$(ls $jsonPath | egrep -c .json$)
if [[ $numKeys > 0 ]];then
   log "Found $numKeys Service Account Keys" INFO
else
   log "No Service Keys Found. Try Again." FAIL
   exit 1
fi
return 0
}

configure_teamdrive_share(){
source $userSettings
[[ ! $(ls $jsonPath | egrep .json$)  ]] && log "configure_teamdrive_share : no jsons found" FAIL && exit 1
[[ -z $teamDrive  ]] && log "configure_teamdrive_share : no teamdrive found in config" FAIL && exit 1
printf "$(grep \"client_email\" ${jsonPath}/*.json | cut -f4 -d'"')\t" > /tmp/clientemails
count=$(cat /tmp/clientemails | wc -l)
cat <<EOF
############ CONFIGURATION ################################
2) In your gdrive, share your teamdrive with
   the $count following emails:
      - tip: uncheck "notify people" & check "prevent editors..."
      - tip: ignore "sharing outside of org warning"

###########################################################
EOF
read -p 'Press Any Key To See The Emails'
cat /tmp/clientemails
echo
echo 'NOTE: you can copy and paste the whole chunk at once'
echo 'If you need to see them again, they are in /tmp/clientemails'
read -p 'Press Any Key To Continue.'
return 0
}

configure_personal_share(){
source $userSettings
[[ ! $(ls $jsonPath | egrep .json$)  ]] && log "configure_personal_share : no jsons found" FAIL && exit 1
printf "$(grep \"client_email\" ${jsonPath}/*.json | cut -f4 -d'"')\t" > /tmp/clientemails
count=$(cat /tmp/clientemails | wc -l)
echo "tip: by default, PG stores media in gdrive on root"
read -p 'Would you like to change where media is stored? y/n> ' answer
if [[ $answer =~ [y|Y|yes|Yes] ]]; then
cat <<EOF
############ CONFIGURATION ################################
1) Create a directory structure like so in your gdrive:

   |___media       <--- rename whatever you like
   | |____movies
   | |____tv
   | |____etc...

NOTE: root_folder is optional, you can put movies into
      /movies , tv into /tv if you want.
NOTE: you can drag and drop existing movies/tv folders here.
###########################################################
EOF
echo "Example: /media     Example2: /data"
read -p 'Enter the name of your root folder for media: ' root
[[ $root == '/' || -z $root ]] && root=''
rootclean=$(sed 's/\//\\\//g' <<<$root)
sed -i '/'^rootDir'=/ s/=.*/='${rootclean}'/' $userSettings
echo
fi

cat <<EOF
############ CONFIGURATION ################################
2) In your gdrive, share your $root folder with
   the $count following emails:
      - tip: uncheck "notify" & check "prevent editors..."
      - tip: ignore "sharing outside of org warning"

###########################################################
EOF
read -p 'Press Any Key To See The Emails'
cat /tmp/clientemails
echo
echo 'NOTE: you can copy and paste the whole chunk at once'
echo 'If you need to see them again, they are in /tmp/clientemails'
read -p 'Press Any Key To Continue.'
return 0
}

configure_Json(){
source ${userSettings}
#rclonePath=$(rclone -h | grep 'Config file. (default' | cut -f2 -d'"')
rclonePath='/root/.config/rclone/rclone.conf'
[[ -e ${rclonePath} ]] || mkdir -p ${rclonePath}
[[ ! $(ls $jsonPath | egrep .json$) ]] && log "No Service Accounts Json Found." FAIL && exit 1
# add rclone config for new keys if not already existing
for json in ${jsonPath}/*.json; do
  if [[ ! $(egrep  '^\[GDSA[0-9]+\]$' -A7 $rclonePath | grep $json) ]]; then
    oldMaxGdsa=$(egrep  '^\[GDSA[0-9]+\]$' $rclonePath | sed 's/\[GDSA//g;s/\]//' | sort -g | tail -1)
    newMaxGdsa=$((++oldMaxGdsa))
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
[[ -n $newGdsaCount ]] && log "$newGdsaCount New Gdrive Service Account Added." INFO
return 0
}

# purge rclone of SA's
purge_Rclone(){
#  rclonePath=$(rclone -h | grep 'Config file. (default' | cut -f2 -d'"')
rclonePath='/root/.config/rclone/rclone.conf'
  del=0
  while read line; do
    if [[ $line == '' ]]; then
    	del=0
    	echo $line >> ${rclonePath}.tmp
    elif [[ $del == 1 || $line =~ ^\[GDSA[0-9]+\]$ ]]; then
    	del=1
    else
    	del=0
    	echo $line >> ${rclonePath}.tmp
    fi
  done <$rclonePath
  cat ${rclonePath}.tmp > $rclonePath
  rm ${rclonePath}.tmp
  if [[ $(egrep '^\[GDSA[0-9]+\]$' -A7 $rclonePath) ]]; then
    log "Failed To Purge Rclone Config." WARN
  else
    log "Rclone Config Purge Successful." INFO
  fi
}
