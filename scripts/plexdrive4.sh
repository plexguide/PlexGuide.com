################# Install Plex
echo -n "Do you want to install PlexDrive? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    clear
    echo "Very Important - Once PlexDrive is running (blue letters)"
    echo "make sure to press CTRL+C. Whatever you do, do not shut"
    echo "down the computer until PlexDrive4 completed the scan."
    echo
    echo "You should see all your folders under /mnt/plexdrive4."
    echo "Again, press CTRL + C once it's running the scan to "
    echo "continue onward."
    echo
    read -n 1 -s -r -p "Press any key to continue"
    clear
    echo Installed PlexDrive; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - PlexDrive
    echo 
fi