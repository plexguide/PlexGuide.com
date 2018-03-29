#!/usr/bin/env bash
#
# DarkerNZBGet theme installer
#
# Version history
# v1.2.0 - 03/28/2018 - Added icon color prompt option and code to copy over the corresponding PNG file.
# v1.1.3 - 03/28/2018 - Added cleanup functionality and made some functions more efficient.
# v1.1.2 - 03/28/2018 - Added additional options checks.
# v1.1.1 - 03/27/2018 - Added functionality to ensure provided Docker container exists on the Server.
# v1.1.0 - 03/27/2018 - Added functionality to install theme to Docker containers.
# v1.0.0 - 03/26/2018 - The original.
#
# Created by: Tronyx

# Determine if user is root and, if not, tell them to use sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run the script as root or use sudo when executing this script..."
  exit
fi

# Define local install or Docker container options
function usage {
  cat <<EOM
~*DarkerNZBGet Theme Installer*~

Usage: $(basename "$0") [OPTION]...

-i VALUE    Install type:
            -i local
            -i docker

-c VALUE    Docker container name
            -c nzbget

-h          Display usage

Specfify the Nzbget installation type with the -i option:
Local install: sudo ./install.sh -i local
Docker container: sudo ./install.sh -i docker
If you specify Docker, you must provide the Nzbget container name.
Provide the Docker container name with the -c option:
Container called nzbget: sudo ./install.sh -i docker -c nzbget
EOM

exit 2
}

while getopts "hi:c:" OPTION
  do
  case "$OPTION" in
    i)
      installType="$OPTARG"
      ;;
    c)
      dockerContainer="$OPTARG"
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
    h|*)
      usage
      ;;
  esac
done

if [[ $1 == "" ]]; then
  usage
  exit 1
elif ! [[ "$installType" =~ ^(local|docker)$  ]]; then
  usage
  exit 1
elif [[ "$installType" == "docker" && "$dockerContainer" == "" ]]; then
  usage
  exit 1
fi


# Prompt user to choose black or white icons and validate correct options
#function choose_color {
#  read -p 'Which icon color do you want? ([w]hite or [b]lack): ' color
#  if ! [[ "$color" =~ ^(black|b|white|w)$  ]]; then
#    echo "Please specify black, b, white, or w."
#    read -p 'Which icon color do you want? ([w]hite or [b]lack): ' color
#  else
#    :
#  fi
#}
color='black'

# Determine if provided Docker container name is valid
function validate_container {
  docker ps --format '{{.Names}}' > /tmp/containers_list.txt
  if grep -q "${dockerContainer}" /tmp/containers_list.txt; then
    echo "Provided Docker container name is valid, continuing..."
  else
    echo "Provided Docker container name is NOT valid!"
    exit 1
  fi
}

# Determine which Package Manager to use
function package_manager {
  echo "Gathering some information and setting some variables..."
  declare -A osInfo;
  osInfo[/etc/redhat-release]='yum -y -q'
  osInfo[/etc/arch-release]=pacman
  osInfo[/etc/gentoo-release]=emerge
  osInfo[/etc/SuSE-release]=zypp
  osInfo[/etc/debian_version]='apt-get -y -qq'

  for f in "${!osInfo[@]}"
    do
      if [[ -f $f ]];then
        packageManager=${osInfo[$f]}
      fi
    done
}

# Determine Nzbget install location and set it as a variable
function get_nzb_dir {
  nzbgetDir=$(locate nzbget |grep conf |head -1 |rev |cut -c12-50 |rev)
}

# Determine Docker AppData dir for NZBget container
function get_appdata_dir {
  appDataDir=$(docker inspect "${dockerContainer}" |grep -A5 -i hostconfig |grep config |rev |cut -c11-50 |rev |tr -d '"' |tr -d ' ')
}

# Make sure unzip and wget are installed
function install_packages {
  echo "Making sure unzip and wget are installed..."
  ${packageManager} install unzip wget
}

# Grab the Darker Nzbget theme CSS archive and extract it
function grab_archive {
  echo "Downloading and extracting the Darker Nzbget theme CSS archive..."
  wget -q -O /tmp/DarkerNZBget.zip https://github.com/ydkmlt84/DarkerNZBget/archive/develop.zip
  unzip -qq -o /tmp/DarkerNZBget.zip -d /tmp/
}

# Display banner
function display_banner {
  cat /tmp/DarkerNZBget-develop/Misc/art.txt
}

# Create backup dir and make a backup of the existing style.css and icons.png files
function backup {
  echo "Backing up the original style.css and icons.png files..."
  if [[ "${installType}" = "local" ]]; then
    if [ ! -d "${nzbgetDir}webui/backup" ]; then
      mkdir -p "${nzbgetDir}webui/backup"
      yes |cp -rf "${nzbgetDir}webui/style.css" "${nzbgetDir}webui/backup/style.css.original"
      yes |cp -rf "${nzbgetDir}webui/img/icons.png" "${nzbgetDir}webui/backup/icons.png.original"
    else
      :
    fi
  elif [[ "${installType}" = "docker" ]]; then
    mkdir -p "${appDataDir}"/backup
    docker cp "${dockerContainer}":/app/nzbget/webui/style.css "${appDataDir}"/backup/style.css.original
    docker cp "${dockerContainer}":/app/nzbget/webui/img/icons.png "${appDataDir}"/backup/icons.png.original
  fi
}

# Install the DarkerNZBget CSS and icons.png files
function install_theme {
  echo "Installing the custom CSS and icons files..."
  if [[ "${installType}" = "local" ]]; then
    if [[ -f "${nzbgetDir}webui/backup/style.css.original" && -f "${nzbgetDir}webui/backup/icons.png.original" ]]; then
      echo "Whoops.. Somehow the stock files didn't get backed up..."
      echo "Let's try that again..."
      yes |cp -rf "${nzbgetDir}webui/style.css" "${nzbgetDir}webui/backup/style.css.original"
      yes |cp -rf "${nzbgetDir}webui/img/icons.png" "${nzbgetDir}webui/backup/icons.png.original"
      echo "Installing the custom CSS and icons files...again..."
      yes |cp -rf /tmp/DarkerNZBget-develop/nzbget_custom_darkblue.css "${nzbgetDir}webui/style.css"
        if [[ "${color}" =~ ^(black|b)$ ]]; then
          yes |cp -rf /tmp/DarkerNZBget-develop/Misc/black_icons.png "${nzbgetDir}webui/img/icons.png"
        elif [[ "${color}" =~ ^(white|w)$ ]]; then
          yes |cp -rf /tmp/DarkerNZBget-develop/Misc/white_icons.png "${nzbgetDir}webui/img/icons.png"
        fi
    else
      yes |cp -rf /tmp/DarkerNZBget-develop/nzbget_custom_darkblue.css "${nzbgetDir}webui/style.css"
      if [[ "${color}" =~ ^(black|b)$ ]]; then
        yes |cp -rf /tmp/DarkerNZBget-develop/Misc/black_icons.png "${nzbgetDir}webui/img/icons.png"
      elif [[ "${color}" =~ ^(white|w)$ ]]; then
        yes |cp -rf /tmp/DarkerNZBget-develop/Misc/white_icons.png "${nzbgetDir}webui/img/icons.png"
      fi
    fi
  elif [[ "${installType}" = "docker" ]]; then
    if [[ ! -f "${appDataDir}/backup/style.css.original" ]]; then
      echo "Whoops.. Somehow the stock files didn't get backed up..."
      echo "Let's try that again..."
      docker cp "${dockerContainer}":/app/nzbget/webui/style.css "${appDataDir}"/backup/style.css.original
      docker cp "${dockerContainer}":/app/nzbget/webui/img/icons.png "${appDataDir}"/backup/icons.png.original
      echo "Installing the custom CSS and icons files...again..."
      docker cp /tmp/DarkerNZBget-develop/nzbget_custom_darkblue.css "${dockerContainer}":/app/nzbget/webui/style.css
      if [[ "${color}" =~ ^(black|b)$ ]]; then
        docker cp /tmp/DarkerNZBget-develop/Misc/black_icons.png "${dockerContainer}":/app/nzbget/webui/img/icons.png
      elif [[ "${color}" =~ ^(white|w)$ ]]; then
        docker cp /tmp/DarkerNZBget-develop/Misc/white_icons.png "${dockerContainer}":/app/nzbget/webui/img/icons.png
      fi
    else
      docker cp /tmp/DarkerNZBget-develop/nzbget_custom_darkblue.css "${dockerContainer}":/app/nzbget/webui/style.css
      if [[ "${color}" =~ ^(black|b)$ ]]; then
        docker cp /tmp/DarkerNZBget-develop/Misc/black_icons.png "${dockerContainer}":/app/nzbget/webui/img/icons.png
      elif [[ "${color}" =~ ^(white|w)$ ]]; then
        docker cp /tmp/DarkerNZBget-develop/Misc/white_icons.png "${dockerContainer}":/app/nzbget/webui/img/icons.png
      fi
    fi
  fi
}

# Cleanup downloaded and extracted dirs and files
function cleanup {
  echo "Tidying some things up..."
  rm -rf /tmp/DarkerNZBget* /tmp/containers_list.txt
}

# Verify the DarkerNZBget CSS has been installed and display corresponding message(s)
function validate_install {
  echo "Validating that the DarkerNZBget theme was installed..."
  if [[ "${installType}" = "local" ]]; then
    if grep -q DarkerNZBget "${nzbgetDir}webui/style.css"; then
      echo "The DarkerNZBget theme has been successfully installed!"
      echo "Please refresh your browser window/tab to see the new theme."
    else
      echo "The DarkerNZBget theme has NOT been installed!"
    fi
  elif [[ "${installType}" = "docker" ]]; then
    if docker exec "${dockerContainer}" grep -q DarkerNZBget app/nzbget/webui/style.css; then
      echo "The DarkerNZBget theme has been successfully installed!"
      echo "Please refresh your browser window/tab to see the new theme."
      echo "NOTE: You will need to run this script every time you recreate the container!"
    else
      echo "The DarkerNZBget theme has NOT been installed!"
    fi
  fi
}

# Execute functions
choose_color
if [[ "${installType}" = "local" ]]; then
  package_manager
  get_nzb_dir
  install_packages
elif [[ "${installType}" = "docker" ]]; then
  validate_container
  get_appdata_dir
fi
grab_archive
display_banner
backup
install_theme
cleanup
validate_install
