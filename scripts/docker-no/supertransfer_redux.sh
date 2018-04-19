############################################################################
# SETTINGS
############################################################################
gdsaDB=/tmp/gdsaLoadBal.txt
gdsaImpersonate=kevin@pham.design
localDir=/mnt/move
modTime=1
uploadHistory=/tmp/superTransferUploadHistory.txt

############################################################################
# INIT
############################################################################
# get list of avail gdsa accounts
gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
if [[ -n $gdsaList ]]; then
    numGdsa=$(echo $gdsaList | wc -w)
    maxDailyUpload=$(python3 -c "round($numGdsa * 750 / 1000, 3")
    echo -e "[INFO]\tInitializing $numGdsa Service Accounts:\t${maxDailyUpload}TB Max Daily Upload"
    echo -e "[INFO]\tValidating Domain Wide Impersonation:\t$gdsaImpersonate"
else
    echo -e "[FAIL]\tNo Valid SA accounts found! Is Rclone Configured With GDSA## remotes?"
    exit 1
fi

# validate gdsaList, purge broken gdsa's & init db
echo '' > $gdsaDB
for gdsa in $gdsaList; do
  if [[ $(rclone --drive-impersonate $gdsaImpersonate ${gdsa}:/ ) ]]; then
    echo "${gdsa}=0" >> $gdsaDB
    echo -e "[INFO]\tGDSA Impersonation Success:\t ${gdsa}.json"
  else
    gdsaList=$(echo $gdsaList | sed 's/'$gdsa'//')
    ((++gdsaFail))
    echo -e "[WARN]\tGDSA Impersonation Failure:\t ${gdsa}.json"
  fi
sleep 0.5
done

[[ -n $gdsaFail ]] \
&& echo -e "[WARN]\t$gdsaFail Failure(s). Did you enable Domain Wide Impersonation In your Google Security Settings?"

[[ -e $uploadHistory ]] || touch $uploadHistory

############################################################################
# Least Usage Load Balancing of GDSA Accounts
############################################################################
gdsaLeast=$(sort -gr -k2 -t'=' $gdsaDB | tail -1 | cut -f1 -d'=')

source $gdsaDB

uploadQueueBuffer=$(find $localDir -mindepth 2 -mmin +${modTime} -type f \
  -exec du -s {} \; | awk -F'\t' '{print $1 "\t" "\"" $2 "\""}' | sort -gr)

# iterate through uploadQueueBuffer and update gdsaDB, incrementing usage values
while read -r line; do
  gdsaLeast=$(sort -gr -k2 -t'=' $gdsaDB | tail -1 | cut -f1 -d'=')
  # skip on files already queued or uploaded
  if [[ ! $(grep $line $uploadHistory) ]]; then
    echo "$gdsaLeast $line $(date +s%)" >> $uploadHistory
    file=$(awk '{print $2}' <<< $line)
    fileSize=$(awk '{print $1}' <<< $line)
    oldUsage=$(awk -F'=' '/^'$gdsaLeast'=./ {print $2}' $gdsaDB)
    newUsage=$(( $oldUsage + $fileSize ))
    # update gdsaUsage file with latest usage value
    sed -i '/'^$gdsaLeast'=/ s/=.*/='$newUsage'/' $gdsaDB
    echo "uploading $filesize $file to $gdsaLeast"
  fi
done <<< "$uploadQueueBuffer"

echo "script end"
