from misc.log import logger
import json
import requests

log = logger.get_logger(__name__)


def get_rating(apikey, movie):
    imdbID = movie['movie']['ids']['imdb']
    if(imdbID):
        log.debug("Requesting ratings from OMDB for %s (%d) | Genres: %s | Country: %s | imdbID: %s", movie['movie']['title'], movie['movie']['year'],
                  ', '.join(movie['movie']['genres']), movie['movie']['country'].upper(), imdbID)
        r = requests.get('http://www.omdbapi.com/?i=' +
                         imdbID + '&apikey=' + apikey)
        if(r.status_code == 200):
            log.debug("Successfully requested ratings from OMDB for %s (%d) | Genres: %s | Country: %s | imdbID: %s",
                      movie['movie']['title'], movie['movie']['year'],
                      ', '.join(movie['movie']['genres']), movie['movie']['country'].upper(), imdbID)
            for source in json.loads(r.text)["Ratings"]:
                if(source['Source'] == 'Rotten Tomatoes'):
                    log.debug("Rotten Tomatoes shows rating: %s for %s (%d) | Genres: %s | Country: %s | imdbID: %s ", source['Value'], movie['movie']['title'], movie['movie']['year'],
                              ', '.join(movie['movie']['genres']), movie['movie']['country'].upper(), imdbID)
                    return int(source['Value'].split('%')[0])
        else:
            log.debug("Error encountered when requesting ratings from OMDB for %s (%d) | Genres: %s | Country: %s | imdbID: %s",
                      movie['movie']['title'], movie['movie']['year'],
                      ', '.join(movie['movie']['genres']), movie['movie']['country'].upper(), imdbID)
    else:
        log.debug("Skipping %s (%d) | Genres: %s | Country: %s as it does not have an imdbID",
                  movie['movie']['title'], movie['movie']['year'],
                  ', '.join(movie['movie']['genres']), movie['movie']['country'].upper())

    return -1
