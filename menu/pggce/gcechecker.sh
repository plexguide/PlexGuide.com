#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
file1="/dev/nvme0n1"
file2="/pg/var/gce.check"
gcheck=$(dnsdomainname | tail -c 10)
  if [ -e "$file1" ] && [ ! -e "$file2" ] && [ "$gcheck" == ".internal" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  Google Cloud Feeder Edition SET!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡  Google Cloud Instance Detected!

⚠️  NOTE: Setting Up the NVME Drive For You! Please Wait!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 3
      mkfs.ext4 -F /dev/nvme0n1 1>/dev/null 2>&1
      mount -o discard,defaults,nobarrier /dev/nvme0n1 /mnt
      chmod a+w /mnt 1>/dev/null 2>&1
      echo UUID=`blkid | grep nvme0n1 | cut -f2 -d'"'` /mnt ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab

      mkdir -p /nvme1 1>/dev/null 2>&1
      mkfs.ext4 -F /dev/nvme0n1
      mount -o discard,defaults,nobarrier /dev/nvme0n1 /nvme1
      chmod a+w /nvme1 1>/dev/null 2>&1
      echo UUID=`blkid | grep nvme0n1 | cut -f2 -d'"'` /nvme1 ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab

      touch /pg/var/gce.check
      rm -rf /pg/var/gce.failed 1>/dev/null 2>&1
      rm -rf /pg/var/gce.false 1>/dev/null 2>&1

      echo "feeder" > /pg/var/pg.server.deploy
      cat /pg/var/pg.edition > /pg/var/pg.edition.stored

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  GCE Harddrive Deployed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡  Automatically Setting PG Google Feeder Edition (GCE)

⚠️  Please Wait!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 6
elif [ ! -e "$file1" ] && [ ! -e "$file2" ] && [ "$gcheck" == ".internal" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  Google Cloud Feeder Edition Failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡  Google Cloud Instance Detected, but you Failed to setup an NVME
   drive per the wiki! This mistake only occurs on manual GCE
   deployments. Most likely you setup an SSD instead! The install will
   continue, but this will fail! Wipe the box and setup again with an
   NVME Drive!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p 'Press [ENTER] to Continue! ' typed < /dev/tty
rm -rf /pg/var/gce.failed 1>/dev/null 2>&1
rm -rf /pg/var/gce.false 1>/dev/null 2>&1
else
    touch /pg/var/gce.false
fi
