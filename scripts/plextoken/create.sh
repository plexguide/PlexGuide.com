token=$(curl -H "Content-Length: 0" -H "X-Plex-Client-Identifier: PlexInTheCloud" -u "${plexUsername}":"${plexPassword}" -X POST https://my.plexapp.com/users/sign_in.xml | cut -d "\"" -s -f22 | tr -d '\n')

# Grab the Plex Section ID of our new TV show library
tvID=$(curl -H "X-Plex-Token: ${token}" http://127.0.0.1:32400/library/sections | grep "show" | grep "title=" | awk -F = '{print $6" "$7" "$8}' | sed 's/ art//g' | sed 's/title//g' | sed 's/type//g' | awk -F \" '{print "Section=\""$6"\" ID="$2}' | cut -d '"' -f2)

    #sleep 4

    #bash /opt/plexguide/scripts/plextoken/test.sh
    #plextoken=$(cat /opt/appdata/plexguide/plextoken)
    #plextoken="claim-$plextoken"
    #echo "claim-NARF" > /opt/appdata/plexguide/plextoken
    #echo "$plextoken" > /opt/appdata/plexguide/plextoken
