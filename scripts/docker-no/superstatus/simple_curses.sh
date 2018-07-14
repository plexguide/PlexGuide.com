#!/bin/bash
#simple curses library to create windows on terminal
#
#author: Patrice Ferlet metal3d@copix.org
#license: new BSD
#
#create_buffer patch by Laurent Bachelier
#
#restriction to local variables and
#rename variables to ones which will not collide
#by Markus Mikkolainen
#
#support for bgcolors by Markus Mikkolainen
#
#support for delay loop function (instead of sleep,
#enabling keyboard input) by Markus Mikkolainen

bsc_create_buffer(){
    local BUFFER_DIR
    # Try to use SHM, then $TMPDIR, then /tmp
    if [ -d "/dev/shm" ]; then
        BUFFER_DIR="/dev/shm"
    elif [ -n "$TMPDIR" ]; then
        BUFFER_DIR="$TMPDIR"
    else
        BUFFER_DIR="/tmp"
    fi
    local buffername
    [[ "$1" != "" ]] &&  buffername=$1 || buffername="bashsimplecurses"

    # Try to use mktemp before using the unsafe method
    if [ -x `which mktemp` ]; then
        #mktemp --tmpdir=${BUFFER_DIR} ${buffername}.XXXXXXXXXX
        mktemp ${BUFFER_DIR}/${buffername}.XXXXXXXXXX
    else
        echo "${BUFFER_DIR}/bashsimplecurses."$RANDOM
    fi
}

#Usefull variables
BSC_LASTCOLS=0
BSC_BUFFER=`bsc_create_buffer`
BSC_POSX=0
BSC_POSY=0
BSC_LASTWINPOS=0

#call on SIGINT and SIGKILL
#it removes buffer before to stop
bsc_on_kill(){
    tput cup 0 0 >> $BSC_BUFFER
    # Erase in-buffer
    tput ed >> $BSC_BUFFER
    rm -rf $BSC_BUFFER
    reset_colors
    tput cnorm
    exit 0
}
trap bsc_on_kill SIGINT SIGTERM


#initialize terminal
bsc_term_init(){
    BSC_POSX=0
    BSC_POSY=0
    tput clear >> $BSC_BUFFER
    tput civis >> $BSC_BUFFER
}


#change line
bsc__nl(){
    BSC_POSY=$((BSC_POSY+1))
    tput cup $BSC_POSY $BSC_POSX >> $BSC_BUFFER
    #echo
}


move_up(){
    set_position $BSC_POSX 0
}

col_right(){
    left=$((BSC_LASTCOLS+BSC_POSX))
    set_position $left $BSC_LASTWINPOS
}

#put display coordinates
set_position(){
    BSC_POSX=$1
    BSC_POSY=$2
}

#initialize chars to use
_TL="\033(0l\033(B"
_TR="\033(0k\033(B"
_BL="\033(0m\033(B"
_BR="\033(0j\033(B"
_SEPL="\033(0t\033(B"
_SEPR="\033(0u\033(B"
_VLINE="\033(0x\033(B"
_HLINE="\033(0q\033(B"
_DIAMOND="\033(00\033(B"
_BLOCK="\033(01\033(B"
_SPINNER=('-' '\' '|' '/')

bsc_init_chars(){
    if [[ -z "$BSC_ASCIIMODE" && $LANG =~ .*\.UTF-8 ]] ; then BSC_ASCIIMODE=utf8; fi
    if [[ "$BSC_ASCIIMODE" != "" ]]; then
        if [[ "$BSC_ASCIIMODE" == "ascii" ]]; then
            _TL="+"
            _TR="+"
            _BL="+"
            _BR="+"
            _SEPL="+"
            _SEPR="+"
            _VLINE="|"
            _HLINE="-"
            _DIAMOND="*"
            _BLOCK="#"
        fi
        if [[ "$BSC_ASCIIMODE" == "utf8" ]]; then
            _TL="\xE2\x94\x8C"
            _TR="\xE2\x94\x90"
            _BL="\xE2\x94\x94"
            _BR="\xE2\x94\x98"
            _SEPL="\xE2\x94\x9C"
            _SEPR="\xE2\x94\xA4"
            _VLINE="\xE2\x94\x82"
            _HLINE="\xE2\x94\x80"
            _DIAMOND="\xE2\x97\x86"
            _BLOCK="\xE2\x96\x88"
        fi
    fi
}


#Append a windo on BSC_POSX,BSC_POSY
window(){
    BSC_LASTWINPOS=$BSC_POSY
    local title
    local color
    local bgcolor
    title=$1
    color=$2
    bgcolor=$4
    tput cup $BSC_POSY $BSC_POSX
    bsc_cols=$(tput cols)
    bsc_cols=$((bsc_cols))
    if [[ "$3" != "" ]]; then
        bsc_cols=$3
        if [ $(echo $3 | grep "%") ];then
            bsc_cols=$(tput cols)
            bsc_cols=$((bsc_cols))
            local w
            w=$(echo $3 | sed 's/%//')
            bsc_cols=$((w*bsc_cols/100))
        fi
    fi
    local len
    len=$(echo "$1" | echo $(($(wc -c)-1)))
    bsc_left=$(((bsc_cols/2) - (len/2) -1))

    #draw up line
    clean_line
    echo -ne $_TL
    local i
    for i in `seq 3 $bsc_cols`; do echo -ne $_HLINE; done
    echo -ne $_TR
    #next line, draw title
    bsc__nl

    tput sc
    clean_line
    echo -ne $_VLINE
    tput cuf $bsc_left
    #set title color
    setcolor $color
    setbgcolor $bgcolor

    echo $title
    setcolor
    setbgcolor
    tput rc
    tput cuf $((bsc_cols-1))
    echo -ne $_VLINE
    reset_colors
    bsc__nl
    #then draw bottom line for title
    addsep

    BSC_LASTCOLS=$bsc_cols

}
reset_colors(){
    echo -n -e "\e[00m"
}
setcolor(){
    local color
    color=$1
    case $color in
        grey|gray)
            echo -ne "\E[01;30m"
            ;;
        red)
            echo -ne "\E[01;31m"
            ;;
        green)
            echo -ne "\E[01;32m"
            ;;
        yellow)
            echo -ne "\E[01;33m"
            ;;
        blue)
            echo -ne "\E[01;34m"
            ;;
        magenta)
            echo -ne "\E[01;35m"
            ;;
        cyan)
            echo -ne "\E[01;36m"
            ;;
        white)
            echo -ne "\E[01;37m"
            ;;
        *) #default should be 39 maybe?
            echo -ne "\E[01;37m"
            ;;
    esac
}
setbgcolor(){
    local bgcolor
    bgcolor=$1
    case $bgcolor in
        grey|gray)
            echo -ne "\E[01;40m"
            ;;
        red)
            echo -ne "\E[01;41m"
            ;;
        green)
            echo -ne "\E[01;42m"
            ;;
        yellow)
            echo -ne "\E[01;43m"
            ;;
        blue)
            echo -ne "\E[01;44m"
            ;;
        magenta)
            echo -ne "\E[01;45m"
            ;;
        cyan)
            echo -ne "\E[01;46m"
            ;;
        white)
            echo -ne "\E[01;47m"
            ;;
        black)
            echo -ne "\E[01;49m"
            ;;
        *) #default should be 49
            echo -ne "\E[01;49m"
            ;;
    esac

}
#append a separator, new line
addsep (){
    clean_line
    echo -ne $_SEPL
    setcolor $1
    setbgcolor $2
    local i
    for i in `seq 3 $bsc_cols`; do echo -ne $_HLINE; done
    setcolor
    setbgcolor
    echo -ne $_SEPR
    bsc__nl
}


#clean the current line
clean_line(){
    tput sc
    #tput el
    tput rc

}


#add text on current window
append_file(){
    local align
    [[ "$1" != "" ]] && align="left" || align=$1
    local l
    IFS=''
    while read l;do
        l=`echo $l | sed 's/____SPACES____/ /g'`
        l=$(echo $l |cut -c 1-$((BSC_LASTCOLS - 2)) )
        bsc__append "$l" $align $2 $3
    done < "$1"
    unset IFS

    setcolor
    setbgcolor
}
#
#   blinkenlights <text> <color> <color2> <incolor> <bgcolor> <light1> [light2...]
#
blinkenlights(){
    local color
    local color2
    local incolor
    local bgcolor
    local lights
    local col
    local text
    text=$1
    color=$2
    color2=$3
    incolor=$4
    bgcolor=$5

    declare -a params
    params=( "$@" )
    unset params[0]
    unset params[1]
    unset params[2]
    unset params[3]
    unset params[4]
    params=( "${params[@]}" )

    lights=""
    while [ -n "$params" ];do
        col=$incolor
        [ "${params[0]}" == "1" ] && col=$color
        [ "${params[0]}" == "2" ] && col=$color2
        lights="${lights} ${_DIAMOND} ${col} ${bgcolor}"
        unset params[0]
        params=( "${params[@]}" )
    done

    bsc__multiappend "left" "[" $incolor $bgcolor $lights "]" $incolor $bgcolor $white "${text}"
}

#
#   vumeter <text> <width> <value> <max> [color] [color2] [inactivecolor] [bgcolor]
#
vumeter(){
    local done
    local todo
    local over
    local len
    local max

    local green
    local red
    local rest

    local incolor
    local okcolor
    local overcolor
    text=$1
    len=$2
    value=$3
    max=$4
    len=$(( len - 2 ))
    incolor=$7
    okcolor=$5
    overcolor=$6
    [ "$incolor" == "" ] && incolor="grey"
    [ "$okcolor" == "" ] && okcolor="green"
    [ "$overcolor" == "" ] && overcolor="red"

    done=$(( value * len / max  + 1 ))
    todo=$(( len - done - 1))

    [ "$(( len * 2 / 3 ))" -lt "$done" ] && {
        over=$(( done - ( len * 2 /3 )))
        done=$(( len * 2 / 3 ))
    }
    green=""
    red=""
    rest=""

    for i in `seq 1 $(($done))`;do
        green="${green}|"
    done
    for i in `seq 0 $(($over))`;do
        red="${red}|"
    done
    red=${red:1}
    for i in `seq 0 $(($todo))`;do
        rest="${rest}."
    done
    [ "$red" == ""  ] && bsc__multiappend "left" "[" $incolor "black" "${green}" $okcolor "black" "${rest}]" $incolor "black" $white "${text}" "black"
    [ "$red" != ""  ] && bsc__multiappend "left" "[" $incolor "black" "${green}" $okcolor "black" "${red}" $overcolor "black" "${rest}]" $incolor "black" $white "${text}" "black"
}
#
#
#
#   progressbar <length> <progress> <max> [color] [bgcolor]
#
progressbar(){
    local done
    local todo
    local len
    local progress
    local max
    local bar
    local modulo
    len=$1
    progress=$2
    [[ $3 > 0 && $3 =~ [0-9] ]] && max=$3 || max=100
    spinvar=$(cat /tmp/rclone_spinner)
    [[ -z $spinvar ]] && spinvar=4
    len=$(( len - 2 ))

    done=$(( progress * len / max))
    todo=$(( len - done - 1))
    modulo=$(( $spinvar % 4 ))
    bar="[";
    for i in `seq 0 $(($done))`;do
        bar="${bar}${_BLOCK}"
    done
    bar="${bar}${_SPINNER[modulo]}"
    for i in `seq 0 $(($todo))`;do
        bar="${bar} "
    done
    bar="${bar}]"
    bsc__append "$bar" "left" $4 $5
}
append(){
    text=$(echo -e $1 | fold -w $((BSC_LASTCOLS-2)) -s)
    rbuffer=`bsc_create_buffer bashsimplecursesfilebuffer`
    echo  -e "$text" > $rbuffer

    local a
    while read a; do
        bsc__append "$a" $2 $3 $4
    done < $rbuffer
    rm -f $rbuffer
}
#
#   append a single line of text consisting of multiple
#   segments
#   bsc__multiappend <centering> (<text> <color> <bgcolor>)+
#
bsc__multiappend(){
    local len
    local text
    declare -a params
    params=( "$@" )
    text=""
    unset params[0]
    params=( "${params[@]}" )
    while [ -n "$params" ];do
        text="${text}${params[0]}"
        unset params[0]
        unset params[1]
        unset params[2]
        params=( "${params[@]}" )
    done
    clean_line
    tput sc
    echo -ne $_VLINE
    len=$(echo "$text" | wc -c )
    len=$((len-1))
    bsc_left=$((BSC_LASTCOLS/2 - len/2 -1))

    params=( "$@")
    [[ "${params[0]}" == "left" ]] && bsc_left=0
    unset params[0]
    params=( "${params[@]}" )
    tput cuf $bsc_left
    while [ -n "${params}" ];do
        setcolor "${params[1]}"
        setbgcolor "${params[2]}"
        echo -ne "${params[0]}"
        setcolor
        setbgcolor
        unset params[0]
        unset params[1]
        unset params[2]
        params=( "${params[@]}" )
    done
    tput rc
    tput cuf $((BSC_LASTCOLS-1))
    echo -ne $_VLINE
    bsc__nl
}
#
#   bsc__append <text> [centering] [color] [bgcolor]
#
bsc__append(){
    clean_line
    tput sc
    echo -ne $_VLINE
    local len
    len=$(echo "$1" | wc -c )
    len=$((len-1))
    bsc_left=$((BSC_LASTCOLS/2 - len/2 -1))

    [[ "$2" == "left" ]] && bsc_left=0

    tput cuf $bsc_left
    setcolor $3
    setbgcolor $4
    echo -e "$1"
    setcolor
    setbgcolor
    tput rc
    tput cuf $((BSC_LASTCOLS-1))
    echo -ne $_VLINE
    bsc__nl
}

#add separated values on current window
append_tabbed(){
    [[ $2 == "" ]] && echo "append_tabbed: Second argument needed" >&2 && exit 1
    [[ "$3" != "" ]] && delim=$3 || delim=":"
    clean_line
    tput sc
    echo -ne $_VLINE
    local len
    len=$(echo "$1" | wc -c )
    len=$((len-1))
    bsc_left=$((BSC_LASTCOLS/$2))

    setcolor $4
    setbgcolor $5
    local i
    for i in `seq 0 $(($2))`; do
        tput rc
        tput cuf $((bsc_left*i+1))
        echo "`echo $1 | cut -f$((i+1)) -d"$delim"`" | cut -c 1-$((bsc_left-2))
    done

    setcolor
    setbgcolor
    tput rc
    tput cuf $((BSC_LASTCOLS-1))
    echo -ne $_VLINE
    bsc__nl
}

#append a command output
append_command(){
    local buff
    buff=`bsc_create_buffer command`
    echo -e "`$1`" 2>&1 | fold -w $((BSC_LASTCOLS - 2)) -s | sed 's/ /____SPACES____/g' > $buff
    setcolor $2
    setbgcolor $3
    append_file $buff "left"
    rm -f $buff
    setcolor
    setbgcolor
}

#close the window display
endwin(){
    clean_line
    echo -ne $_BL
    for i in `seq 3 $BSC_LASTCOLS`; do echo -ne $_HLINE; done
    echo -ne $_BR
    bsc__nl
}

#refresh display
refresh (){
    cat $BSC_BUFFER
    echo "" > $BSC_BUFFER
}



#main loop called
main_loop (){
    bsc_term_init
    bsc_init_chars
    local time
    local number_re
    #everything starting with a number is a number
    number_re='^[0-9]+.*$'
    time=1
    [[ "$1" == "" ]] || time=$1
    while [[ 1 ]];do
        tput cup 0 0 >> $BSC_BUFFER
        tput il $(tput lines) >>$BSC_BUFFER
        main >> $BSC_BUFFER
        tput cup $(tput lines) $(tput cols) >> $BSC_BUFFER
        refresh
        if ! [[ $time =~ $number_re ]] ; then
            #call function with name $time
            eval $time
            retval=$?
            [ "$retval" == "0" ] || {
                reset_colors
                exit $retval
            }
        else
            sleep $time
        fi
        BSC_POSX=0
        BSC_POSY=0
    done
}
