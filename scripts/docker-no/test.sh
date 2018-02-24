timestamp() {
  date +"%Y-%m-%d-%T"
}

# 
mkdir /mnt/gdrive/plexguide/backup.old/
mkdir /mnt/gdrive/plexguide/backup.old/backup-{timestamp}
mv /mnt/gdrive/plexguide/backup /mnt/drive/plexguide/backup.old/backup-{timestamp}

timestamp # print timestamp
# do something else...
timestamp 

docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running

while read p; do
  echo $p > /tmp/program_var
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup
done </opt/appdata/plexguide/running
