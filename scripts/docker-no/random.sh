#!/bin/bash

MAXCOUNT=1
count=1

while [ "$count" -le $MAXCOUNT ]
do
  number=$RANDOM
  let "count += 1"  # Increment count.
done

RANGE=4

number=$RANDOM
let "number %= $RANGE"

if [ "$number" -eq "0" ]
then
   echo "0"
fi


if [ "$number" -eq "1" ]
then
   echo "1"
fi

if [ "$number" -eq "2" ]
then
   echo "2"
fi

if [ "$number" -eq "3" ]
then
   echo "3"
fi

if [ "$number" -eq "4" ]
then
   echo "4"
fi


echo
exit 0
