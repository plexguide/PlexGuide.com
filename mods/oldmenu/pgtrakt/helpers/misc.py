from copy import copy

from misc.log import logger

log = logger.get_logger(__name__)


def get_response_dict(response, key_field=None, key_value=None):
    found_response = None
    try:
        if isinstance(response, list):
            if not key_field or not key_value:
                found_response = response[0]
            else:
                for result in response:
                    if isinstance(result, dict) and key_field in result and result[key_field] == key_value:
                        found_response = result
                        break

                if not found_response:
                    log.error("Unable to find a result with key %s where the value is %s", key_field, key_value)

        elif isinstance(response, dict):
            found_response = response
        else:
            log.error("Unexpected response instance type of %s for %s", type(response).__name__, response)

    except Exception:
        log.exception("Exception determining response for %s: ", response)
    return found_response


def backoff_handler(details):
    log.warning("Backing off {wait:0.1f} seconds afters {tries} tries "
                "calling function {target} with args {args} and kwargs "
                "{kwargs}".format(**details))


def dict_merge(dct, merge_dct):
    for k, v in merge_dct.items():
        import collections

        if k in dct and isinstance(dct[k], dict) and isinstance(merge_dct[k], collections.Mapping):
            dict_merge(dct[k], merge_dct[k])
        else:
            dct[k] = merge_dct[k]

    return dct


def unblacklist_genres(genre, blacklisted_genres):
    genres = genre.split(',')
    for allow_genre in genres:
        if allow_genre in blacklisted_genres:
            blacklisted_genres.remove(allow_genre)
    return


def allowed_genres(genre, object_type, trakt_object):
    allowed_object = False
    genres = genre.split(',')

    for item in genres:
        if item.lower() in trakt_object[object_type]['genres']:
            allowed_object = True
            break
    return allowed_object


def sorted_list(original_list, list_type, sort_key, reverse=True):
    prepared_list = copy(original_list)
    for item in prepared_list:
        if not item[list_type][sort_key]:
            if sort_key == 'released' or sort_key == 'first_aired':
                item[list_type][sort_key] = ""
            else:
                item[list_type][sort_key] = 0

    return sorted(prepared_list, key=lambda k: k[list_type][sort_key], reverse=reverse)


# reference: https://stackoverflow.com/a/16712886
def substring_after(s, delim):
    return s.partition(delim)[2]
