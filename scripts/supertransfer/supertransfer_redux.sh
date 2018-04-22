############################################################################
# INIT
############################################################################
source rcloneupload.sh
source init.sh
source settings.conf
source usersettings.conf

# init functions
cat_Art
# prompt user to upload json if none
[[ $(egrep .json$ <<<$(ls $jsonPath)) ]] && upload_Json
configure_Json
init_DB

############################################################################
# Least Usage Load Balancing of GDSA Accounts
############################################################################
uploadQueueBuffer=$(find $localDir -mindepth 2 -mmin +${modTime} -type f \
  -exec du -s {} \; | awk -F'\t' '{print $1 "\t" "\"" $2 "\""}' | sort -gr)

# iterate through uploadQueueBuffer and update gdsaDB, incrementing usage values
while read -r line; do
  gdsaLeast=$(sort -gr -k2 -t'=' $gdsaDB | tail -1 | cut -f1 -d'=')
  # skip on files already queued or uploaded
  if [[ ! $(grep $line $uploadHistory) ]]; then
    file=$(awk '{print $2}' <<< $line)
    fileSize=$(awk '{print $1}' <<< $line)
    rclone_upload $gdsaLeast $file $remoteDir &
    # add timestamp & log
    echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\t$gdsaLeast\tStarting Upload: $file"
    echo "$gdsaLeast $line $(date +s%)" >> $uploadHistory

    # load latest usage value from db
    source $gdsaDB
    Usage=$(( $gdsaLeast + $fileSize ))
    # update gdsaUsage file with latest usage value
    sed -i '/'^$gdsaLeast'=/ s/=.*/='$Usage'/' $gdsaDB
  fi
done <<< "$uploadQueueBuffer"

echo "script end"
