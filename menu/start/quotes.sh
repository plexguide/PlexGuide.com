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
echo "Well, because I just realized that everything I've been doing up to now,
the bathing, the tooth brushing, changing of the socks, being nice to people,
trying to succeed…it's all for nothing. All those things are designed to 
attract. Why should I be attractive? I'm married...with children." > /var/plexguide/startup.quote
echo "                                         Al Bundy ~ Married With Children" > /var/plexguide/startup.source
}




# END FUNCTIONS ################################################################
num=$( echo $(($RANDOM % 5)) )
quote$num
