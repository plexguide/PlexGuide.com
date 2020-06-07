from misc.log import logger
import json
import requests

log = logger.get_logger(__name__)


def get_movie_rt_score(omdb_api_key, movie_title, movie_year, movie_imdb_id):
    """
    Lookup movie ratings via OMDb

    :param omdb_api_key: OMDb API Key
    :param movie_title: Movie Title
    :param movie_year: Movie Year
    :param movie_imdb_id: Movie IMDb ID
    :return: Rating score (int) or False if no rating found
    """

    ratings_exist = False

    if movie_imdb_id:
        log.debug("Requesting info from OMDb for: \'%s (%s)\' [IMDb ID: %s]",
                  movie_title,
                  movie_year,
                  movie_imdb_id)
        r = requests.get('http://www.omdbapi.com/?i=' + movie_imdb_id + '&apikey=' + omdb_api_key)
        if r.status_code == 200 and json.loads(r.text)["Response"] == 'True':
            log.debug("Successfully requested ratings from OMDB for \'%s (%s)\' [IMDb ID: %s]",
                      movie_title,
                      movie_year,
                      movie_imdb_id)
            for source in json.loads(r.text)["Ratings"]:
                if source['Source'] == 'Rotten Tomatoes':
                    # noinspection PyUnusedLocal
                    ratings_exist = True
                    log.debug("Rotten Tomatoes score for \'%s (%s)\' [IMDb ID: %s]: %s",
                              movie_title,
                              movie_year,
                              movie_imdb_id,
                              source['Value'])
                    return int(source['Value'].split('%')[0])
            if not ratings_exist:
                log.debug("No Rotten Tomatoes score found for: \'%s (%s)\' [IMDb ID: %s]",
                          movie_title,
                          movie_year,
                          movie_imdb_id)
        else:
            log.debug("Error encountered when requesting ratings from OMDb for: \'%s (%s)\' [IMDb ID: %s]",
                      movie_title,
                      movie_year,
                      movie_imdb_id)
    else:
        log.debug("Skipping OMDb ratings lookup because no IMDb ID was found for: \'%s (%s)\'",
                  movie_title,
                  movie_year)

    return False


def does_movie_have_min_req_rt_score(omdb_api_key, movie_title, movie_year, movie_imdb_id, min_req_rt_score):

    # pull RT score
    movie_rt_score = get_movie_rt_score(omdb_api_key, movie_title, movie_year, movie_imdb_id)

    if not movie_rt_score:
        log.info("SKIPPING: \'%s (%s)\' because a Rotten Tomatoes score could not be found.", movie_title,
                 movie_year)
        return False
    elif movie_rt_score < min_req_rt_score:
        log.info("SKIPPING: \'%s (%s)\' because its Rotten Tomatoes score of %d%% is below the required score of %d%%.",
                 movie_title, movie_year, movie_rt_score, min_req_rt_score)
        return False
    elif movie_rt_score >= min_req_rt_score:
        log.info("ADDING: \'%s (%s)\' because its Rotten Tomatoes score of %d%% is above the required score of %d%%.",
                 movie_title, movie_year, movie_rt_score, min_req_rt_score)
        return True
