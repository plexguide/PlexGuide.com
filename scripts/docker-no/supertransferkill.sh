#!/bin/bash 
ps -ef | grep supertransfer | grep -v grep | awk '{print }' | xargs kill; 
exit 0
