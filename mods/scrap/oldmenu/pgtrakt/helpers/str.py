from misc.log import logger

log = logger.get_logger(__name__)


def get_year_from_timestamp(timestamp):
    year = 0
    try:
        if not timestamp:
            return 0

        year = timestamp[:timestamp.index('-')]
    except Exception:
        log.exception("Exception parsing year from %s: ", timestamp)
    return int(year) if str(year).isdigit() else 0


def is_ascii(string):
    try:
        string.encode('ascii')
    except UnicodeEncodeError:
        return False
    except UnicodeDecodeError:
        return False
    except Exception:
        log.exception(u"Exception checking if %r was ascii: ", string)
        return False
    return True


def ensure_endswith(data, endswith_key):
    if not data.strip().endswith(endswith_key):
        return "%s%s" % (data.strip(), endswith_key)
    else:
        return data
