from misc.log import logger

log = logger.get_logger(__name__)


def filter_trakt_movies_list(trakt_movies, callback):
    new_movies_list = []
    try:
        for tmp in trakt_movies:
            if 'movie' not in tmp or 'ids' not in tmp['movie'] or 'tmdb' not in tmp['movie']['ids']:
                log.debug("Removing movie from Trakt list as it did not have the required fields: %s", tmp)
                if callback:
                    callback('movie', tmp)
                continue
            new_movies_list.append(tmp)

        return new_movies_list
    except Exception:
        log.exception("Exception filtering Trakt movies list: ")
    return None


def movies_to_tmdb_dict(radarr_movies):
    movies = {}

    try:
        for tmp in radarr_movies:
            if 'tmdbId' not in tmp:
                log.debug("Could not handle movie: %s", tmp['title'])
                continue
            movies[tmp['tmdbId']] = tmp
        return movies
    except Exception:
        log.exception("Exception processing Radarr movies to TMDB dict: ")
    return None


def remove_existing_movies(radarr_movies, trakt_movies, callback=None):
    new_movies_list = []

    try:
        # turn radarr movies result into a dict with tmdb id as keys
        processed_movies = movies_to_tmdb_dict(radarr_movies)
        if not processed_movies:
            return None

        # loop list adding to movies that do not already exist
        for tmp in trakt_movies:
            # check if movie exists in processed_movies
            if tmp['movie']['ids']['tmdb'] in processed_movies:
                movie_year = str(tmp['movie']['year']) if tmp['movie']['year'] else '????'
                log.debug("Removing existing movie: \'%s (%s)\'", tmp['movie']['title'], movie_year)
                if callback:
                    callback('movie', tmp)
                continue
            new_movies_list.append(tmp)

        removal_successful = True if len(new_movies_list) <= len(trakt_movies) else False

        movies_removed_count = len(trakt_movies) - len(new_movies_list)
        log.debug("Filtered %d movies from Trakt list that were already in Radarr.", movies_removed_count)

        return new_movies_list, removal_successful
    except Exception:
        log.exception("Exception removing existing movies from Trakt list: ")
    return None


def exclusions_to_tmdb_dict(radarr_exclusions):
    movie_exclusions = {}

    try:
        for tmp in radarr_exclusions:
            if 'tmdbId' not in tmp:
                log.debug("Could not handle movie: %s", tmp['movieTitle'])
                continue
            movie_exclusions[tmp['tmdbId']] = tmp
        return movie_exclusions
    except Exception:
        log.exception("Exception processing Radarr movie exclusions to TMDB dict: ")
    return None


def remove_existing_exclusions(radarr_exclusions, trakt_movies, callback=None):
    new_movies_list = []

    try:
        # turn radarr movie exclusions result into a dict with tmdb id as keys
        processed_movies = exclusions_to_tmdb_dict(radarr_exclusions)
        if not processed_movies:
            return None

        # loop list adding to movies that do not already exist
        for tmp in trakt_movies:
            # check if movie exists in processed_movies
            if tmp['movie']['ids']['tmdb'] in processed_movies:
                movie_year = str(tmp['movie']['year']) if tmp['movie']['year'] else '????'
                log.debug("Removing excluded movie: \'%s (%s)\'", tmp['movie']['title'], movie_year)
                if callback:
                    callback('movie', tmp)
                continue
            new_movies_list.append(tmp)

        movies_removed_count = len(trakt_movies) - len(new_movies_list)
        log.debug("Filtered %d movies from Trakt list that were excluded in Radarr.", movies_removed_count)

        return new_movies_list
    except Exception:
        log.exception("Exception removing excluded movies from Trakt list: ")
    return None


def remove_existing_and_excluded_movies(radarr_movies, radarr_exclusions, trakt_movies, callback=None):
    if not radarr_movies or not trakt_movies:
        log.error("Inappropriate parameters were supplied.")
        return None, False

    try:
        # clean up trakt_movies list
        trakt_movies = filter_trakt_movies_list(trakt_movies, callback)
        if not trakt_movies:
            return None, False

        # filter out existing movies in radarr from new trakt list
        processed_movies_list, removal_successful = remove_existing_movies(radarr_movies, trakt_movies, callback)
        if not processed_movies_list:
            return None, removal_successful

        # filter out radarr exclusions from the list above
        if radarr_exclusions:
            processed_movies_list = remove_existing_exclusions(radarr_exclusions, processed_movies_list, callback)

        movies_removed_count = len(trakt_movies) - len(processed_movies_list)
        log.debug("Filtered a total of %d movies from the Trakt movies list.", movies_removed_count)
        log.debug("New Trakt movies list count: %d", len(processed_movies_list))
        return processed_movies_list, removal_successful
    except Exception:
        log.exception("Exception removing existing and excluded movies from Trakt list: ")
    return None
