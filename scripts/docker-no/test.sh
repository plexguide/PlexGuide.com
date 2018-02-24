timestamp() {
  date +"%Y-%m-%d-%T"
}

mfolder="/mnt/gdrive/plexguide/backup.old/backup-"
$mpath="$mfolder$timestamp"
echo "path is"
echo $mfolder
echo $mpath

# 
mkdir /mnt/gdrive/plexguide/backup.old/
mkdir $mpath
mv /mnt/gdrive/plexguide/backup $mpath

timestamp # print timestamp
# do something else...
timestamp 

docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running

while read p; do
  echo $p > /tmp/program_var
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup
done </opt/appdata/plexguide/running
