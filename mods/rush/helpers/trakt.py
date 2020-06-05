from helpers import str as misc_str
from misc.log import logger

log = logger.get_logger(__name__)


def extract_list_user_and_key_from_url(list_url):
    try:
        import re
        list_user = re.search('\/users\/([^/]*)', list_url).group(1)
        list_key = re.search('\/lists\/([^/?]*)', list_url).group(1)

        return list_user, list_key
    except:
        log.error('The URL "%s" is not in the correct format', list_url)
    exit()


def blacklisted_show_id(show, blacklisted_ids):
    blacklisted = False
    blacklisted_ids = sorted(map(int, blacklisted_ids))
    try:
        if show['show']['ids']['tvdb'] in blacklisted_ids:
            log.debug("\'%s\' | Blacklisted IDs Check        | Blacklisted because it had a blacklisted TVDB ID: %d",
                      show['show']['title'],
                      show['show']['ids']['tvdb'])
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted IDs Check        | Passed.", show['show']['title'])
    except Exception:
        log.exception("Exception determining if show had a blacklisted TVDB ID %s: ", show)
    return blacklisted


def blacklisted_show_title(show, blacklisted_keywords):
    blacklisted = False
    try:
        if not show['show']['title']:
            log.debug("Blacklisted Titles Check     | Blacklisted show because it had no title: %s", show)
            blacklisted = True
        else:
            for keyword in blacklisted_keywords:
                if keyword.lower() in show['show']['title'].lower():
                    log.debug("\'%s\' | Blacklisted Titles Check     | Blacklisted because it had the title keyword: %s",
                              show['show']['title'], keyword)
                    blacklisted = True
                    break
    except Exception:
        log.exception("Exception determining if show had a blacklisted title %s: ", show)
    return blacklisted


def blacklisted_show_year(show, earliest_year, latest_year):
    blacklisted = False
    try:
        year = misc_str.get_year_from_timestamp(show['show']['first_aired'])
        if not year:
            log.debug("\'%s\' | Blacklisted Years Check      | Blacklisted because it had no "
                      "first-aired date specified.",
                      show['show']['title'])
            blacklisted = True
        else:
            if year < earliest_year or year > latest_year:
                log.debug("\'%s\' | Blacklisted Years Check      | Blacklisted because it first aired in: %d",
                          show['show']['title'], year)
                blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Years Check      | Passed.", show['show']['title'])
    except Exception:
        log.exception("Exception determining if show is within min_year and max_year range %s:", show)
    return blacklisted


def blacklisted_show_network(show, networks):
    blacklisted = False
    try:
        if not show['show']['network']:
            log.debug("\'%s\' | Blacklisted Networks Check   | Blacklisted because it had no network specified.",
                      show['show']['title'])
            blacklisted = True
        else:
            for network in networks:
                if network.lower() in show['show']['network'].lower():
                    log.debug("\'%s\' | Blacklisted Networks Check   | Blacklisted because it's from the network: %s",
                              show['show']['title'], show['show']['network'])
                    blacklisted = True
                    break
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Networks Check   | Passed.", show['show']['title'])
    except Exception:
        log.exception("Exception determining if show is from a blacklisted network %s: ", show)
    return blacklisted


def blacklisted_show_country(show, allowed_countries):
    blacklisted = False
    try:
        # ["ignore"] - add show item even if it is missing a country
        if any('ignore' in s.lower() for s in allowed_countries):
            log.debug("\'%s\' | Blacklisted Countries Check  | Ignored.", show['show']['title'])
        # List provided - skip adding show item because it is missing a country
        elif not show['show']['country']:
            log.debug("\'%s\' | Blacklisted Countries Check  | Blacklisted because it had no country specified.",
                      show['show']['title'])
            blacklisted = True
        # [] - add show item from any valid country
        elif not allowed_countries:
            log.debug("\'%s\' | Blacklisted Countries Check  | Skipped.",
                      show['show']['title'])
        # List provided - skip adding show item if the country is blacklisted
        elif not any(show['show']['country'].lower() in s.lower() for s in allowed_countries):
            log.debug("\'%s\' | Blacklisted Countries Check  | Blacklisted because it's from the country: %s",
                      show['show']['title'],
                      show['show']['country'].upper())
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Countries Check  | Passed.", show['show']['title'])
    except Exception:
        log.exception("Exception determining if show was from an allowed country %s: ", show)
    return blacklisted


def blacklisted_show_language(show, allowed_languages):
    blacklisted = False
    # [] - add show items with 'en' language
    if not allowed_languages:
        allowed_languages = ['en']
    try:
        # ["ignore"] - add show item even if it is missing a language
        if any('ignore' in s.lower() for s in allowed_languages):
            log.debug("\'%s\' | Blacklisted Languages Check  | Ignored.", show['show']['title'])
        # List provided - skip adding show item because it is missing a language
        elif not show['show']['language']:
            log.debug("\'%s\' | Blacklisted Languages Check  | Blacklisted because it had no language specified.",
                      show['show']['title'])
            blacklisted = True
        # List provided - skip adding show item if the language is blacklisted
        elif not any(show['show']['language'].lower() in c.lower() for c in allowed_languages):
            log.debug("\'%s\' | Blacklisted Languages Check  | Blacklisted because it's in the language: %s",
                      show['show']['title'], show['show']['language'].upper())
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Languages Check  | Passed.", show['show']['title'])
    except Exception:
        log.exception("Exception determining what language the show was in %s: ", show)
    return blacklisted


def blacklisted_show_genre(show, genres):
    blacklisted = False
    try:
        # ["ignore"] - add show item even if it is missing a genre
        if any('ignore' in s.lower() for s in genres):
            log.debug("\'%s\' | Blacklisted Genres Check     | Ignored.", show['show']['title'])
        elif not show['show']['genres']:
            log.debug("\'%s\' | Blacklisted Genres Check     | Blacklisted because it had no genre specified.",
                      show['show']['title'])
            blacklisted = True
        # [] - add show item with any valid genre
        elif not genres:
            log.debug("\'%s\' | Blacklisted Genres Check     | Skipped.",
                      show['show']['title'])
        # List provided - skip adding show item if the genre is blacklisted
        else:
            for genre in genres:
                if genre.lower() in show['show']['genres']:
                    log.debug("\'%s\' | Blacklisted Genres Check     | Blacklisted because it was from the genre: %s",
                              show['show']['title'], genre.title())
                    blacklisted = True
                    break
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Genres Check     | Passed.", show['show']['title'])
    except Exception:
        log.exception("Exception determining if show has a blacklisted genre %s: ", show)
    return blacklisted


def blacklisted_show_runtime(show, lowest_runtime):
    blacklisted = False
    try:
        if not show['show']['runtime'] or not isinstance(show['show']['runtime'], int):
            log.debug("\'%s\' | Blacklisted Runtime Check    | Blacklisted because it had no runtime specified.",
                      show['show']['title'])
            blacklisted = True
        elif int(show['show']['runtime']) < lowest_runtime:
            log.debug("\'%s\' | Blacklisted Runtime Check    | Blacklisted because it had the runtime of: %d min.",
                      show['show']['title'], show['show']['runtime'])
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Runtime Check    | Passed.", show['show']['title'])
    except Exception:
        log.exception("Exception determining if show had sufficient runtime %s: ", show)
    return blacklisted


def is_show_blacklisted(show, blacklist_settings, ignore_blacklist, callback=None):
    if ignore_blacklist:
        return False

    blacklisted = False
    try:
        if blacklisted_show_id(show, blacklist_settings.blacklisted_tvdb_ids):
            blacklisted = True
        if blacklisted_show_title(show, blacklist_settings.blacklisted_title_keywords):
            blacklisted = True
        if blacklisted_show_year(show, blacklist_settings.blacklisted_min_year,
                                 blacklist_settings.blacklisted_max_year):
            blacklisted = True
        if blacklisted_show_network(show, blacklist_settings.blacklisted_networks):
            blacklisted = True
        if blacklisted_show_country(show, blacklist_settings.allowed_countries):
            blacklisted = True
        if blacklisted_show_language(show, blacklist_settings.allowed_languages):
            blacklisted = True
        if blacklisted_show_genre(show, blacklist_settings.blacklisted_genres):
            blacklisted = True
        if blacklisted_show_runtime(show, blacklist_settings.blacklisted_min_runtime):
            blacklisted = True
        if blacklisted and callback:
            callback('show', show)
    except Exception:
        log.exception("Exception determining if show was blacklisted %s: ", show)
    return blacklisted


def blacklisted_movie_id(movie, blacklisted_ids):
    blacklisted = False
    blacklisted_ids = sorted(map(int, blacklisted_ids))
    try:
        if movie['movie']['ids']['tmdb'] in blacklisted_ids:
            log.debug("\'%s\' | Blacklisted IDs Check        | Blacklisted because it had a blacklisted TMDb ID: %d",
                      movie['movie']['title'], movie['movie']['ids']['tmdb'])
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted IDs Check        | Passed.", movie['movie']['title'])
    except Exception:
        log.exception("Exception determining if movie had a blacklisted TMDb ID %s: ", movie)
    return blacklisted


def blacklisted_movie_title(movie, blacklisted_keywords):
    blacklisted = False
    try:
        if not movie['movie']['title']:
            log.debug("Blacklisted Titles Check     | Blacklisted movie because it had no title: %s", movie)
            blacklisted = True
        else:
            for keyword in blacklisted_keywords:
                if keyword.lower() in movie['movie']['title'].lower():
                    log.debug("\'%s\' | Blacklisted Titles Check     | Blacklisted because it had the title keyword: %s",
                              movie['movie']['title'], keyword)
                    blacklisted = True
                    break
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Titles Check     | Passed.", movie['movie']['title'])
    except Exception:
        log.exception("Exception determining if movie had a blacklisted title %s: ", movie)
    return blacklisted


def blacklisted_movie_year(movie, earliest_year, latest_year):
    blacklisted = False
    try:
        year = movie['movie']['year']
        if year is None or not isinstance(year, int):
            log.debug("\'%s\' | Blacklisted Years Check      | Blacklisted because it had no year specified.",
                      movie['movie']['title'])
            blacklisted = True
        else:
            if int(year) < earliest_year or int(year) > latest_year:
                log.debug("\'%s\' | Blacklisted Years Check      | Blacklisted because its year is: %d",
                          movie['movie']['title'], int(year))
                blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Years Check      | Passed.", movie['movie']['title'])
    except Exception:
        log.exception("Exception determining if movie is within min_year and max_year ranger %s:", movie)
    return blacklisted


def blacklisted_movie_country(movie, allowed_countries):
    blacklisted = False
    try:
        # ["ignore"] - add movie item even if it is missing a country
        if any('ignore' in s.lower() for s in allowed_countries):
            log.debug("\'%s\' | Blacklisted Countries Check  | Ignored.",
                      movie['movie']['title'])
        # List provided - skip adding movie item because it is missing a country
        elif not movie['movie']['country']:
            log.debug("\'%s\' | Blacklisted Countries Check  | Blacklisted because it had no country specified.",
                      movie['movie']['title'])
            blacklisted = True
        # [] - add movie item with from any valid country
        elif not allowed_countries:
            log.debug("\'%s\' | Blacklisted Countries Check  | Skipped.",
                      movie['movie']['title'])
        # List provided - skip adding movie item if the country is blacklisted
        elif not any(movie['movie']['country'].lower() in s.lower() for s in allowed_countries):
            log.debug("\'%s\' | Blacklisted Countries Check  | Blacklisted because it's from the country: %s",
                      movie['movie']['title'], movie['movie']['country'].upper())
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Countries Check  | Passed.", movie['movie']['title'])
    except Exception:
        log.exception("Exception determining if movie was from an allowed country %s: ", movie)
    return blacklisted


def blacklisted_movie_language(movie, allowed_languages):
    blacklisted = False
    # [] - add movie items with 'en' language
    if not allowed_languages:
        allowed_languages = ['en']
    try:
        # ["ignore"] - add movie item even if it is missing a language
        if any('ignore' in s.lower() for s in allowed_languages):
            log.debug("\'%s\' | Blacklisted Languages Check  | Ignored.",
                      movie['movie']['title'])
        # List provided - skip adding movie item because it is missing a language
        elif not movie['movie']['language']:
            log.debug("\'%s\' | Blacklisted Languages Check  | Blacklisted because it had no language specified.",
                      movie['movie']['title'])
            blacklisted = True
        # List provided - skip adding movie item if the language is blacklisted
        elif not any(movie['movie']['language'].lower() in s.lower() for s in allowed_languages):
            log.debug("\'%s\' | Blacklisted Languages Check  | Blacklisted because it's in the language: %s",
                      movie['movie']['title'], movie['movie']['language'].upper())
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Languages Check  | Passed.", movie['movie']['title'])
    except Exception:
        log.exception("Exception determining what language the movie was %s: ", movie)
    return blacklisted


def blacklisted_movie_genre(movie, genres):
    blacklisted = False
    try:
        # ["ignore"] - add movie item even if it is missing a genre
        if any('ignore' in s.lower() for s in genres):
            log.debug("\'%s\' | Blacklisted Genres Check     | Ignored.", movie['movie']['title'])
        elif not movie['movie']['genres']:
            log.debug("\'%s\' | Blacklisted Genres Check     | Blacklisted because it had no genre specified.",
                      movie['movie']['title'])
            blacklisted = True
        # [] - add movie item with any valid genre
        elif not genres:
            log.debug("\'%s\' | Blacklisted Genres Check     | Skipped.",
                      movie['movie']['title'])
        # List provided - skip adding movie item if the genre is blacklisted
        else:
            for genre in genres:
                if genre.lower() in movie['movie']['genres']:
                    log.debug("\'%s\' | Blacklisted Genres Check     | Blacklisted because it was from the genre: %s",
                              movie['movie']['title'], genre.title())
                    blacklisted = True
                    break
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Genres Check     | Passed.", movie['movie']['title'])
    except Exception:
        log.exception("Exception determining if movie has a blacklisted genre %s: ", movie)
    return blacklisted


def blacklisted_movie_runtime(movie, lowest_runtime):
    blacklisted = False
    try:
        if not movie['movie']['runtime'] or not isinstance(movie['movie']['runtime'], int):
            log.debug("\'%s\' | Blacklisted Runtime Check    | Blacklisted because it had no runtime specified.",
                      movie['movie']['title'])
            blacklisted = True
        elif int(movie['movie']['runtime']) < lowest_runtime:
            log.debug("\'%s\' | Blacklisted Runtime Check    | Blacklisted because it had the runtime of: %d min.",
                      movie['movie']['title'], movie['movie']['runtime'])
            blacklisted = True
        if not blacklisted:
            log.debug("\'%s\' | Blacklisted Runtime Check    | Passed.", movie['movie']['title'])
    except Exception:
        log.exception("Exception determining if movie had sufficient runtime %s: ", movie)
    return blacklisted


def is_movie_blacklisted(movie, blacklist_settings, ignore_blacklist, callback=None):
    if ignore_blacklist:
        return False

    blacklisted = False
    try:
        if blacklisted_movie_id(movie, blacklist_settings.blacklisted_tmdb_ids):
            blacklisted = True
        if blacklisted_movie_title(movie, blacklist_settings.blacklisted_title_keywords):
            blacklisted = True
        if blacklisted_movie_year(movie, blacklist_settings.blacklisted_min_year,
                                  blacklist_settings.blacklisted_max_year):
            blacklisted = True
        if blacklisted_movie_country(movie, blacklist_settings.allowed_countries):
            blacklisted = True
        if blacklisted_movie_language(movie, blacklist_settings.allowed_languages):
            blacklisted = True
        if blacklisted_movie_genre(movie, blacklist_settings.blacklisted_genres):
            blacklisted = True
        if blacklisted_movie_runtime(movie, blacklist_settings.blacklisted_min_runtime):
            blacklisted = True
        if blacklisted and callback:
            callback('movie', movie)
    except Exception:
        log.exception("Exception determining if movie was blacklisted %s: ", movie)
    return blacklisted
