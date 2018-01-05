#!/bin/bash

MAXCOUNT=1
count=1

echo
echo "$MAXCOUNT random numbers:"
echo "-----------------"
while [ "$count" -le $MAXCOUNT ]      # Generate 10 ($MAXCOUNT) random integers.
do
  number=$RANDOM
  echo $number
  let "count += 1"  # Increment count.
done
echo "-----------------"

# If you need a random int within a certain range, use the 'modulo' operator.
# This returns the remainder of a division operation.
RANGE=2
#$number is the endstate
echo

number=$RANDOM
let "number %= $RANGE"

if [ "$number" == 1 ]
then
   echo "1"
else
   echo "5"
fi



echo
exit 0
