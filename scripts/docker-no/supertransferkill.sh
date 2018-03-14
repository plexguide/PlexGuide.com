#!/bin/bash 
ps -ef | grep supertransfer | grep -v "grep" | awk '{print $2}' | xargs kill; 
exit 0
