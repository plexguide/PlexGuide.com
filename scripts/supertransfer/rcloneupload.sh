#!/usr/bin/env bash
# shellcheck disable=SC2154
#                      |---uploadQueueBuffer--|
#usage: rclone_upload  <dirsize> <upload_dir>  <rclone> <remote_root_dir>
rclone_upload() {
  local driveChunkSize
  local gbFileSize
  local gbUsage
  local logfile
  local oldUsage
  local sanitizedLocalFile
  local t1
  local tmp

  local localFile="${2}"
  sanitizedLocalFile=$(sed 's/(/\\(/g; s/)/\\)/g; s/\[/\\[/g; s/\]/\\]/g; s/\^/\\^/g; s/\*/\\*/g; s/"/\\"/g; s/!/\\!/g; s/+/\\+/g' <<<$localFile)
  # exit if file is locked, or race condtion met
  [[ $(egrep -x "${sanitizedLocalFile}" $fileLock) ]] && return 1
  #[[ ! -d "${localFile}" ]] && return 1
  (cd "${localFile}" &>/dev/null) || return 1
  [[ -z $(ls "${localFile}" 2>/dev/null) ]] && return 1
  # lock file so multiple uploads don't happen
  echo "${localFile}" >>$fileLock
  local fileSize="${1}"
  local gdsa="${3}"
  local remoteDir="${4}"
  local rclone_fin_flag=0
  local rclone_fin_flag=0
  t1=$(date +%s)

  # load latest usage value from db
  oldUsage=$(egrep -m1 ^$gdsa=. $gdsaDB | awk -F'=' '{print $2}')
  local Usage=$((oldUsage + fileSize))
  [[ -n $dbug ]] && echo -e " [DBUG]\t$gdsa\tUsage: $Usage"
  # update gdsaUsage file with latest usage value
  sed -i '/'^$gdsa'=/ s/=.*/='$Usage'/' $gdsaDB
  gbFileSize=$(python3 -c "print(round($fileSize/1000000, 1), 'GB')")
  echo -e " [INFO] $gdsaLeast \tUploading: ${localFile#"$localDir"} @${gbFileSize}"
  [[ -n $dbug ]] && gbUsage=$(python3 -c "print(round($Usage/1000000, 2), 'GB')")
  [[ -n $dbug ]] && -e " [DBUG] $gdsaLeast @${gbUsage}"

  # Calculate best chunksize for trasnfer speed.
  AvailableRam=$(free --giga -w | grep Mem | awk '{print $8}')
  case "$AvailableRam" in
  [1-9][0-9] | [1-9][0-9][0-9]) driveChunkSize="1024M" ;;
  [6-9]) driveChunkSize="512M" ;;
  5) driveChunkSize="256M" ;;
  4) driveChunkSize="128M" ;;
  3) driveChunkSize="64M" ;;
  2) driveChunkSize="32M" ;;
  [0-1]) driveChunkSize="8M" ;;
  esac
  #echo "[DBUG] rcloneupload: localFile=${localFile}"
  #echo "[DBUG] rcloneupload: raw input 2=$2"

  tmp="$(echo "${2}" | rev | cut -f1 -d'/' | rev | sed 's/ /_/g; s/\"//g')"
  logfile="${logDir}/${gdsa}_${tmp}.log"
  local rcloneARGS=(
    "--drive-chunk-size=$driveChunkSize"
    "--log-file=${logfile}"
    '--checkers=20'
    '--config /root/.config/rclone/rclone.conf'
    '--exclude="**_HIDDEN~"'
    '--exclude="**partial~"'
    '--exclude=".unionfs-fuse/**"'
    '--exclude=".unionfs/**"'
    '--log-level INFO'
    '--stats 5s'
    '--tpslimit 6'
    '--transfers=8'
  )

  rclone move "${localFile}" "$gdsa:${localFile#"$localDir"}" "${rcloneARGS[@]}" &&
    rclone_fin_flag=1

  # check if rclone finished sucessfully
  local secs=$(($(date +%s) - $t1))
  if [[ $rclone_fin_flag == 1 ]]; then
    printf " [ OK ] $gdsaLeast\tFinished: "${localFile#"$localDir"}" in %dh:%dm:%ds\n" $(($secs / 3600)) $(($secs % 3600/60)) $(($secs % 60))
    sleep 10
    [[ -n $(ls "${localFile}") ]] && sleep 45 # sleep so files are deleted off disk before resuming; good for TV episodes
  else
    printf " [FAIL] $gdsaLeast\tUPLOAD FAILED: "${localFile}" in %dh:%dm:%ds\n" $(($secs / 3600)) $(($secs % 3600/60)) $(($secs % 60))
    cat $logfile >>/tmp/rclonefail.log
    [[ -n $dbug ]] && echo -e " [DBUG]\t$gdsa\tREVERTED Usage: $Usage"
    # revert gdsaDB back to old value if upload failed
    sed -i '/'^$gdsa'=/ s/=.*/='$oldUsage'/' $gdsaDB
  fi
  # release fileLock when file transfer finishes (or fails)
  egrep -xv "${sanitizedLocalFile}" "${fileLock}" >/tmp/fileLock.tmp && mv /tmp/fileLock.tmp ${fileLock}
  [[ -e $logfile ]] && rm -f $logfile
}
