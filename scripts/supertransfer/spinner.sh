
#!/bin/bash

# Author: Tasos Latsas

# /opt/plexguide/scripts/supertransfer/spinner.sh
#
# Display an awesome 'spinner' while running your long shell commands
#
# Do *NOT* call _spinner function directly.
# Use {start,stop}_spinner wrapper functions

# usage:
#   1. source this script in your's
#   2. start the spinner:
#       start_spinner [display-message-here]
#   3. run your command
#   4. stop the spinner:
#       stop_spinner [your command's exit status]
#
# Also see: test.sh


function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)

    local on_success=" OK "
    local on_fail="FAIL"
    local on_crit="CRIT"
    local on_warn="WARN"
    local on_info="INFO"
    local on_cust="$2"
    local spincolor="\e[2m"
    local white="\e[1;37m"
    local yellow="\e[1;33m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local flash="\e[5;1;31m"
    local nc="\e[0m"

    case $1 in
        start)
            # calculate the column where spinner and status msg will be displayed
            #let column=$(tput cols)-${#2}-4
            let column=58-${#2}
            (( $column < 0 )) && let column=8
            # display message and position the cursor in $column column
            echo -ne ${2}
            printf "%${column}s"

            # start spinner
            i=1
            sp="⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆"

            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "\b\b\b\b\b\b[${spincolor}${sp:i++%${#sp}:4}${nc}]"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en "\b\b\b\b\b\b["
            if [[ $2 =~ "WARN" ]]; then
                echo -en "${yellow}${on_warn}${nc}"
            elif [[ $2 =~ "INFO" ]]; then
                echo -en "${white}${on_info}${nc}"
            elif [[ $2 =~ "CRIT" ]]; then
                echo -en "${flash}${on_crit}${nc}"
            elif [[ $2 =~ "FAIL" ]]; then
                echo -en "${red}${on_fail}${nc}"
            elif [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
    sleep 0.01
}

function stop_spinner {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}

function log {
  # usage: log <msg to display> <exit code>
  # WARN == WARN
  # INFO == INFO
  # _200 == CUSTOM
  # 0 == OK
  # * == FAIL
  start_spinner "${1}"
  stop_spinner "${2}"
}
