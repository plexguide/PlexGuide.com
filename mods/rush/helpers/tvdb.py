from misc.log import logger
import requests

log = logger.get_logger(__name__)


def validate_series_tvdb_id(series_title, series_year, series_tvdb_id):
    try:
        if not series_tvdb_id or not isinstance(series_tvdb_id, int):
            log.debug("SKIPPING: \'%s (%s)\' blacklisted it has an invalid TVDB ID", series_title, series_year)
            return False
        else:
            return True
    except Exception:
        log.exception("Exception validating TVDB ID for \'%s (%s)\'.", series_title, series_year)
    return False


def verify_series_exists_on_tvdb(series_title, series_year, series_tvdb_id):
    try:
        req = requests.get('https://www.thetvdb.com/dereferrer/series/%s' % series_tvdb_id, allow_redirects=False)
        if 'This record has either been deleted or has never existed.' not in req.text:
            log.debug("\'%s (%s)\' [TVDB ID: %s] exists on TVDB.", series_title, series_year, series_tvdb_id)
            return True
        else:
            log.debug("SKIPPING: \'%s (%s)\' [TVDB ID: %s] because it does not exist on TVDB.", series_title,
                      series_year, series_tvdb_id)
            return False
    except Exception:
        log.exception("Exception verifying TVDB ID for \'%s (%s)\'.", series_title, series_year)
    return False


def check_series_tvdb_id(series_title, series_year, series_tvdb_id):
    try:
        if validate_series_tvdb_id(series_title, series_year, series_tvdb_id) and \
                verify_series_exists_on_tvdb(series_title, series_year, series_tvdb_id):
            return True
    except Exception:
        log.exception("Exception verifying/validating TVDB ID for \'%s (%s)\'.", series_title, series_year)
    return False
