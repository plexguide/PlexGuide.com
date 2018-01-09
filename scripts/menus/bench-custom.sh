#!/bin/bash

whiptail --title "Advanced System and Bechnmark Options" --checklist "Choose Variables for the Information and Benchmark Run" 15 60 4 \
    "-info" "System Information" OFF \
    "-io" "I/O Test" OFF \
    "-cdn" "CDN Download" OFF \
    "-northamerica" "North America Download" OFF \
    "-europe" "Europe Download" OFF \
    "-asia" "Asia Download"
    3>&1 1>&2 2>&3
