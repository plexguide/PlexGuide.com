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

quote7 () {
echo "I don't care what your doing; it's just the idiotic way that your doing
it!" > /var/plexguide/startup.quote
echo "                                                 Vincent ~ Final Fantasy 7" > /var/plexguide/startup.source
}

quote8 () {
echo "Now, we fight like men! And ladies! And ladies who dress like men!" > /var/plexguide/startup.quote
echo "                                               Gilgamesh ~ Final Fantasy 5" > /var/plexguide/startup.source
}

quote9 () {
echo "Now, we fight like men! And ladies! And ladies who dress like men!" > /var/plexguide/startup.quote
echo "                             Gilgamesh ~ Final Fantasy 5 (ROM Translation)" > /var/plexguide/startup.source
}

quote10 () {
echo "Tomorrow is gonna be just like today, and I know that because today is
just like yesterday!" > /var/plexguide/startup.quote
echo "                                          Dubanowski ~ SuperStore (Cloud9)" > /var/plexguide/startup.source
}

quote11 () {
echo "You don’t win friends with salad!" > /var/plexguide/startup.quote
echo "                                        Homer, Bart & Marge ~ The Simpsons" > /var/plexguide/startup.source
}

quote12 () {
echo "It takes two to lie: one to lie and one to listen." > /var/plexguide/startup.quote
echo "                                                      Homer ~ The Simpsons" > /var/plexguide/startup.source
}

quote13 () {
echo "Loneliness and cheeseburgers are a dangerous mix." > /var/plexguide/startup.quote
echo "                                             Comic Book Guy ~ The Simpsons" > /var/plexguide/startup.source
}

quote14 () {
echo "Hello, 911? It's Quagmire. Yeah, it's caught in the window this time." > /var/plexguide/startup.quote
echo "                                                Glen Quagmire ~ Family Guy" > /var/plexguide/startup.source
}

quote15 () {
echo "My favorite exercise is a cross between a lunge and a crunch...
I call it lunch." > /var/plexguide/startup.quote
echo "                                                  Anonymous ~ The Internet" > /var/plexguide/startup.source
}

quote16 () {
echo "McLovin? What kind of stupid name is that, Fogell? What, are you trying
to be an Irish R&B singer?" > /var/plexguide/startup.quote
echo "                                                           Evan ~ SuperBad" > /var/plexguide/startup.source
}

quote17 () {
echo "Hello, 911 Emergency? There’s a handsome guy in my bathroom! Hey, wait
a second. Cancel that – it’s only me!" > /var/plexguide/startup.quote
echo "                                               Johnny Bravo ~ Johnny Bravo" > /var/plexguide/startup.source
}

quote18 () {
echo "Happy-happy, joy-joy! Happy-happy, joy-joy!" > /var/plexguide/startup.quote
echo "                                            Stimpy ~ The Ren & Stimpy Show" > /var/plexguide/startup.source
}

quote19 () {
echo "Presenting the Cheese-A-Phone. We can communicate with various cheeses,
regardless of foreign tongue. Go ahead, Ren, say something in Limburger" > /var/plexguide/startup.quote
echo "                                            Stimpy ~ The Ren & Stimpy Show" > /var/plexguide/startup.source
}

# END FUNCTIONS ################################################################
num=$( echo $(($RANDOM % 20)) )
quote$num
