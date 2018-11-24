quote1 () {
echo "Manbearpig is in there and we all have to kill him while we all have the
chance, I'm cereal!" > /var/plexguide/startup.quote
echo "                                                       Al Gore ~ SouthPark" > /var/plexguide/startup.source
}

quote2 () {
echo "There are no stupid answers, just stupid people" > /var/plexguide/startup.quote
echo "                                                  Mr. Garrison ~ SouthPark" > /var/plexguide/startup.source
}

quote3 () {
echo "Don't do drugs kids. There is a time and place for everything. It's called
college." > /var/plexguide/startup.quote
echo "                                                          Chef ~ SouthPark" > /var/plexguide/startup.source
}
# END FUNCTIONS ################################################################
highestquote=3

num=$( echo $(($RANDOM % $highestquote)) )
num=num+1
quote$num
