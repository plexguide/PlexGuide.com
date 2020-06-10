from misc.log import logger
import requests

log = logger.get_logger(__name__)


def validate_movie_tmdb_id(movie_title, movie_year, movie_tmdb_id):
    try:
        if not movie_tmdb_id or not isinstance(movie_tmdb_id, int):
            log.debug("SKIPPING: \'%s (%s)\' blacklisted it has an invalid TMDb ID", movie_title, movie_year)
            return False
        else:
            return True
    except Exception:
        log.exception("Exception validating TMDb ID for \'%s (%s)\'.", movie_title, movie_year)
    return False


def verify_movie_exists_on_tmdb(movie_title, movie_year, movie_tmdb_id):
    try:
        req = requests.get('https://www.themoviedb.org/movie/%s' % movie_tmdb_id)
        if req.status_code == 200:
            log.debug("\'%s (%s)\' [TMDb ID: %s] exists on TMDb.", movie_title, movie_year, movie_tmdb_id)
            return True
        else:
            log.debug("SKIPPING: \'%s (%s)\' [TMDb ID: %s] because it does not exist on TMDb.", movie_title, movie_year,
                      movie_tmdb_id)
            return False
    except Exception:
        log.exception("Exception verifying TMDb ID for \'%s (%s)\'.", movie_title, movie_year)
    return False


def check_movie_tmdb_id(movie_title, movie_year, movie_tmdb_id):
    try:
        if validate_movie_tmdb_id(movie_title, movie_year, movie_tmdb_id) and \
                verify_movie_exists_on_tmdb(movie_title, movie_year, movie_tmdb_id):
            return True
    except Exception:
        log.exception("Exception verifying/validating TMDb ID for \'%s (%s)\'.", movie_title, movie_year)
    return False
