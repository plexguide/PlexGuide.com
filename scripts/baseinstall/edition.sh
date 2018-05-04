#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
export NCURSES_NO_UTF8_ACS=1

#hd1=$( cat /var/plexguide/hd/hd1 )

### Determine Variable
deploy=$( cat /var/pg.server.deploy )

  if [ "$deploy" == "gdrive" ]
  then
    stat1=" <<< Current Use" 1>/dev/null 2>&1
  else
    stat1="" 1>/dev/null 2>&1
  fi

  if [ "$deploy" == "drive" ]
  then
    stat2=" <<< Current Use" 1>/dev/null 2>&1
  else
    stat2="" 1>/dev/null 2>&1
  fi

  if [ "$deploy" == "drives" ]
  then
    stat3=" <<< Current Use" 1>/dev/null 2>&1
  else
    stat3="" 1>/dev/null 2>&1
  fi

HEIGHT=11
WIDTH=41
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Select Your Edition!"

OPTIONS=(A "GDrive Edition$stat1"
         B "HD Solo Edition$stat2"
         C "HD Multi Edition$stat3"
         D "Mini FAQ")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
######################### GDRIVE
  if [ "$deploy" == "gdrive" ]
  then
    exit
  else
    clear 1>/dev/null 2>&1
  fi
      dialog --title "Quick Note" --msgbox "\nWARNING! Switching to another edition from a previous working one may result in certain things being shutdown!\n\nWe will do our best to ensure that you can transition to any edition!" 0 0
      bash /opt/plexguide/menus/confirm.sh 

      ### Confirm yes or no to skip back to menu    
      menu=$( cat /tmp/menu.choice )
      if [ "$menu" == "yes" ]
        then

          ### If SOLO Drive was active before, important to move item to an old folder
          if [ "$deploy" == "drive" ]
            then
              dialog --title "Quick Note" --msgbox "\nWARNING! Your Items from /mnt/unionfs need to move to either /mnt/old/ for storage reasons or /mnt/move for GDrive Uploading!" 0 0
              
                ### Make a Move Choice
                HEIGHT=9
                WIDTH=50
                CHOICE_HEIGHT=2
                BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
                TITLE="Solo HD >>> GDrive Edition"
                MENU="Switching To GDrive Will Move your Current!"

                OPTIONS=(A "To /mnt/old  - For Storage"
                         B "To /mnt/move - For Google Uploads")

                CHOICE=$(dialog --backtitle "$BACKTITLE" \
                                --title "$TITLE" \
                                --menu "$MENU" \
                                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                "${OPTIONS[@]}" \
                                2>&1 >/dev/tty)

                case $CHOICE in
                ######################### HANDLING
                A)
                dialog --title "Quick Note" --msgbox "\nTo /mnt/old your DATA for storage it goes!" 0 0
                mkdir /mnt/old 1>/dev/null 2>&1
                mv /mnt/unionfs/* /mnt/old 1>/dev/null 2>&1
                ;;

                B)
                dialog --title "Quick Note" --msgbox "\nTo /mnt/move your DATA for uploading it goes!" 0 0
                mv /mnt/unionfs/* /mnt/move 1>/dev/null 2>&1
                ;;
                esac
              fi

          ### If MULTI Drive was active before, switch over
          if [ "$deploy" == "drives" ]
            then

                ### Make a Move Choice
                HEIGHT=9
                WIDTH=50
                CHOICE_HEIGHT=2
                BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
                TITLE="Multi HD >>> GDrive Edition"
                MENU="Switching To GDrive Will Stop Your Drives Pool!"

                OPTIONS=(A "Yes: Switch"
                         B "No : Back Out")

                CHOICE=$(dialog --backtitle "$BACKTITLE" \
                                --title "$TITLE" \
                                --menu "$MENU" \
                                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                "${OPTIONS[@]}" \
                                2>&1 >/dev/tty)

                case $CHOICE in
                ######################### HANDLING
                A)
                systemctl stop drives 1>/dev/null 2>&1
                systemctl disable drives 1>/dev/null 2>&1
                systemctl daemon-reload 1>/dev/null 2>&1
                ;;

                B)
                bash /opt/plexguide/scripts/baseinstall/edition.sh  
                exit
                ;;
                esac
              fi

                ### Set Everything for GDrive Editon
                echo "PG Edition: GDrive" > /var/plexguide/pg.edition
                echo "gdrive" > /var/pg.server.deploy
                bash /opt/plexguide/menus/main.sh
                exit
              else 
                bash /opt/plexguide/scripts/baseinstall/edition.sh  
                exit
              fi

              exit
              ;;
######################### MULTI
    C)
  if [ "$deploy" == "drives" ]
  then
    exit
  else
    clear 1>/dev/null 2>&1
  fi
      dialog --title "Quick Note" --msgbox "\nWARNING! Switching to another edition from a previous working may result in certain things being shutdown!\n\nWe will do our best to ensure that you can transition to any edition!" 0 0
      bash /opt/plexguide/menus/confirm.sh 

      ### Confirm yes or no to skip back to menu    
      menu=$( cat /tmp/menu.choice )
      if [ "$menu" == "yes" ]
        then

         ### If Solo Drive was active before, important to move item to an old folder
          if [ "$deploy" == "drive" ]
            then

                ### Make a Move Choice
                HEIGHT=9
                WIDTH=50
                CHOICE_HEIGHT=2
                BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
                TITLE="Solo HD >>> Multi HD Edition"
                MENU="Switching To Multi HD Will Move your Current!"

                OPTIONS=(A "To /mnt/old  - For Storage"
                         B "No : Back Out")

                CHOICE=$(dialog --backtitle "$BACKTITLE" \
                                --title "$TITLE" \
                                --menu "$MENU" \
                                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                "${OPTIONS[@]}" \
                                2>&1 >/dev/tty)

                case $CHOICE in
                ######################### HANDLING
                A)

                dialog --title "Quick Note" --msgbox "\nTo /mnt/old your DATA for storage it goes!" 0 0
                mkdir /mnt/old 1>/dev/null 2>&1
                mv /mnt/unionfs/* /mnt/old 1>/dev/null 2>&1
                systemctl stop drive 1>/dev/null 2>&1
                systemctl disable drive 1>/dev/null 2>&1
                systemctl daemon-reload 1>/dev/null 2>&1
                ;;

                B)
                bash /opt/plexguide/scripts/baseinstall/edition.sh  
                exit
                ;;
                esac
              fi

         if [ "$deploy" == "gdrive" ]
                    then

                        ### Make a Move Choice
                        HEIGHT=9
                        WIDTH=50
                        CHOICE_HEIGHT=2
                        BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
                        TITLE="Switching To Solo HD will disable your Google Setup"
                        TITLE="GDrive Edition >>> Multi HD Edition"
                        MENU="Switching To Multi HD Will Stop GDrive!"

                        OPTIONS=(A "Yes: Switch"
                                 B "No : Back Out")

                        CHOICE=$(dialog --backtitle "$BACKTITLE" \
                                        --title "$TITLE" \
                                        --menu "$MENU" \
                                        $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                        "${OPTIONS[@]}" \
                                        2>&1 >/dev/tty)

                        case $CHOICE in
                        ######################### HANDLING
                        A)
                        systemctl stop unionfs 1>/dev/null 2>&1
                        systemctl disable unionfs 1>/dev/null 2>&1
                        systemctl stop unionfs-en 1>/dev/null 2>&1
                        systemctl disable unionfs-en 1>/dev/null 2>&1
                        systemctl stop move-en 1>/dev/null 2>&1
                        systemclt disable move-en 1>/dev/null 2>&1
                        systemctl daemon-reload 1>/dev/null 2>&1
                        ;;

                        B)
                        bash /opt/plexguide/scripts/baseinstall/edition.sh  
                        exit
                        ;;
                        esac
                      fi


        ### Set Everything for HD Multi Editon
        echo "PG Edition: HD Multi" > /var/plexguide/pg.edition
        echo "drives" > /var/pg.server.deploy
        bash /opt/plexguide/menus/drives/multideploy.sh
        bash /opt/plexguide/menus/localmain.sh
        systemctl enable drives 1>/dev/null 2>&1
        systemctl start drives 1>/dev/null 2>&1
        systemctl daemon-reload 1>/dev/null 2>&1
        exit
      else 
        bash /opt/plexguide/scripts/baseinstall/edition.sh  
        exit
      fi

      exit
      ;;
######################### SOLO
    B)
  if [ "$deploy" == "drive" ]
  then
    exit
  else
    clear 1>/dev/null 2>&1
  fi
      dialog --title "Quick Note" --msgbox "\nWARNING! Switching to another edition from a previous working may result in certain things being shutdown!\n\nWe will do our best to ensure that you can transition to any edition!" 0 0

      
      bash /opt/plexguide/menus/confirm.sh 

      ### Confirm yes or no to skip back to menu    
      menu=$( cat /tmp/menu.choice )
      if [ "$menu" == "yes" ]
        then

       if [ "$deploy" == "drives" ]
                  then

                      ### Make a Move Choice
                      HEIGHT=9
                      WIDTH=50
                      CHOICE_HEIGHT=2
                      BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
                      TITLE="Multi HD Edition >>> Solo Edition"
                      MENU="Switching To Solo HD will stop your Pool!"

                      OPTIONS=(A "Yes: Switch"
                               B "No : Back Out")

                      CHOICE=$(dialog --backtitle "$BACKTITLE" \
                                      --title "$TITLE" \
                                      --menu "$MENU" \
                                      $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                      "${OPTIONS[@]}" \
                                      2>&1 >/dev/tty)

                      case $CHOICE in
                      ######################### HANDLING
                      A)
                      systemctl stop drives 1>/dev/null 2>&1
                      systemctl disable drives 1>/dev/null 2>&1
                      systemctl daemon-reload 1>/dev/null 2>&1
                      ;;

                      B)
                      bash /opt/plexguide/scripts/baseinstall/edition.sh  
                      exit
                      ;;
                      esac
                    fi

         if [ "$deploy" == "gdrive" ]
                    then

                        ### Make a Move Choice
                        HEIGHT=9
                        WIDTH=50
                        CHOICE_HEIGHT=2
                        BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
                        TITLE="GDrive Edition >>> Solo HD"
                        MENU="Switching To Solo HD will stop GDrive!"

                        OPTIONS=(A "Yes: Switch"
                                 B "No : Back Out")

                        CHOICE=$(dialog --backtitle "$BACKTITLE" \
                                        --title "$TITLE" \
                                        --menu "$MENU" \
                                        $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                        "${OPTIONS[@]}" \
                                        2>&1 >/dev/tty)

                        case $CHOICE in
                        ######################### HANDLING
                        A)

                        ### disable
                        systemctl stop unionfs 1>/dev/null 2>&1
                        systemctl disable unionfs 1>/dev/null 2>&1
                        systemctl stop unionfs-en 1>/dev/null 2>&1
                        systemctl disable unionfs-en 1>/dev/null 2>&1
                        systemctl stop move-en 1>/dev/null 2>&1
                        systemclt disable move-en 1>/dev/null 2>&1
                        systemctl daemon-reload 1>/dev/null 2>&1
                        systemctl daemon-reload 1>/dev/null 2>&1
                        ;;

                        B)
                        bash /opt/plexguide/scripts/baseinstall/edition.sh  
                        exit
                        ;;
                        esac
                      fi


        #### Switch to Solo
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags folders_solo &>/dev/null &
        echo "PG Edition: HD Solo" > /var/plexguide/pg.edition
        echo "drive" > /var/pg.server.deploy
        bash /opt/plexguide/menus/drives/solodeploy.sh
        bash /opt/plexguide/menus/localmain.sh
        systemctl enable drive 1>/dev/null 2>&1
        systemctl start drive 1>/dev/null 2>&1
        systemctl daemon-reload 1>/dev/null 2>&1

        exit
      else 
        bash /opt/plexguide/scripts/baseinstall/edition.sh  
        exit
      fi

      exit
      ;;
######################### FAQ
    D)
      dialog --title "Quick FAQ" --msgbox "\nYou can pick between using your local drives or Google Drive for your mass media storage collection.\n\nBe aware the HDs option is not ready and is here for testing/demo purposes until ready.\n\nSolo HD is setup for smaller collections; download, watch, and delete. The multiple HD edition is for those who use multiple drives to build a collection!" 0 0
      bash /opt/plexguide/scripts/baseinstall/edition.sh  
      exit
      ;;
######################### EXIT
    Z)
      bash /opt/plexguide/scripts/baseinstall/edition.sh  
      exit
      ;;
esac
#bash /opt/plexguide/scripts/baseinstall/edition.sh