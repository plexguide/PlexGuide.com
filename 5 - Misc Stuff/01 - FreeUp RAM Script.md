# FreeUp RAM Script
- Credit: Admin9705
- Free's Up RAM every 30 minutes

## Create the Script

```sh
sudo nano /opt/freeram.sh
```
### Paste into the Script

```sh
#!/bin/bash

echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
```

- Press CTRL+X and ENTER; creating a CRONJOB as ROOT 

```sh
sudo su
crontab -e
```

- Add to very bottom line: 
```sh
*/30 * * * * /bin/bash /opt/freeram.sh >/dev/null 2>&1
```
- Press CTRL+X and set the permissions and return as USER

```sh
sudo chmod 755 /opt/freeram.sh
sudo chown root /opt/freeram.sh
exit
```

- Reboot! The script will kick in every 30 minutes
