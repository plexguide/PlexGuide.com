quote1 () {
echo "Manbearpig is in there and we all have to kill him while we all have the
chance, I'm cereal!" > /var/plexguide/startup.quote
echo "                                                       Al Gore ~ SouthPark" > /var/plexguide/startup.source
}

quote2 () {
echo "There are no stupid answers, just stupid people" > /var/plexguide/startup.quote
echo "                                                  Mr. Garrison ~ SouthPark" > /var/plexguide/startup.source
}


# END FUNCTIONS ################################################################
num=$( echo $(($RANDOM % 2)) )
quote2
