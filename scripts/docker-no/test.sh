timestamp() {
  date +"date +%Y-%m-%d+%T"
}

# do something...
timestamp # print timestamp
# do something else...
timestamp 

docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running

while read p; do
  echo $p > /tmp/program_var
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup
done </opt/appdata/plexguide/running
