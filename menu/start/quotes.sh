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

quote4 () {
echo "I left you plenty of food. It's at the supermarket." > /var/plexguide/startup.quote
echo "                                       Peggy Bundy ~ Married With Children" > /var/plexguide/startup.source
}

quote5 () {
echo "Dad had one great dream, a dream that had been handed down from
generation to generation of male Bundys: to build their own room and live
separately, from their wives. Sadly, they all failed." > /var/plexguide/startup.quote
echo "                                          Al Bundy ~ Married With Children" > /var/plexguide/startup.source
}

quote6 () {
echo "Look, Al doesn’t like me blowing smoke in his eggs. What am I supposed to
do? Stop smoking?" > /var/plexguide/startup.quote
echo "                                       Peggy Bundy ~ Married With Children" > /var/plexguide/startup.source
}
# END FUNCTIONS ################################################################
num=$( echo $(($RANDOM % 7)) )
quote$num
