#!/bin/bash

MAXCOUNT=1
count=1

while [ "$count" -le $MAXCOUNT ]
do
  number=$RANDOM
  echo $number
  let "count += 1"  # Increment count.
done

RANGE=3

echo

number=$RANDOM
let "number %= $RANGE"

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

echo
exit 0
