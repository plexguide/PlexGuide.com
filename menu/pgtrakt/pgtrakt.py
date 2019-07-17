#!/usr/bin/env python3
import os.path
import signal
import sys
import time

import click
import schedule

from pyfiglet import Figlet

############################################################
# INIT
############################################################
cfg = None
log = None
notify = None


# Click
@click.group(help='Add new shows & movies to Sonarr/Radarr from Trakt.')
@click.version_option('1.2.3', prog_name='pgtrakt')
@click.option(
    '--config',
    envvar='TRAKTARR_CONFIG',
    type=click.Path(file_okay=True, dir_okay=False),
    help='Configuration file',
    show_default=True,
    default=os.path.join(os.path.dirname(
        os.path.realpath(sys.argv[0])), "config.json")
)
@click.option(
    '--logfile',
    envvar='TRAKTARR_LOGFILE',
    type=click.Path(file_okay=True, dir_okay=False),
    help='Log file',
    show_default=True,
    default=os.path.join(os.path.dirname(
        os.path.realpath(sys.argv[0])), "activity.log")
)
def app(config, logfile):
    # Setup global variables
    global cfg, log, notify

    # Load config
    from misc.config import Config
    cfg = Config(config_path=config, logfile=logfile).cfg

    # Load logger
    from misc.log import logger
    log = logger.get_logger('pgtrack')

    # Load notifications
    from notifications import Notifications
    notify = Notifications()

    # Notifications
    init_notifications()


############################################################
# Trakt OAuth
############################################################

@app.command(help='Authenticate traktarr.')
def trakt_authentication():
    from media.trakt import Trakt
    trakt = Trakt(cfg)

    if trakt.oauth_authentication():
        log.info("Authentication information saved; please restart the application")
        exit()


def validate_trakt(trakt, notifications):
    if not trakt.validate_client_id():
        log.error("Aborting due to failure to validate Trakt API Key")
        if notifications:
            callback_notify(
                {'event': 'error', 'reason': 'Failure to validate Trakt API Key'})
        exit()
    else:
        log.info("Validated Trakt API Key")


def validate_pvr(pvr, type, notifications):
    if not pvr.validate_api_key():
        log.error("Aborting due to failure to validate %s URL / API Key", type)
        if notifications:
            callback_notify(
                {'event': 'error', 'reason': 'Failure to validate %s URL / API Key' % type})
        return None
    else:
        log.info("Validated %s URL & API Key", type)


def get_profile_id(pvr, profile):
    # retrieve profile id for requested profile
    profile_id = pvr.get_profile_id(profile)
    if not profile_id or not profile_id > 0:
        log.error("Aborting due to failure to retrieve Profile ID for: %s", profile)
        exit()
    log.info("Retrieved Profile ID for %s: %d", profile, profile_id)
    return profile_id


def get_profile_tags(pvr):
    profile_tags = pvr.get_tags()
    if profile_tags is None:
        log.error("Aborting due to failure to retrieve Tag ID's")
        exit()
    log.info("Retrieved %d Tag ID's", len(profile_tags))
    return profile_tags


def get_objects(pvr, type, notifications):
    objects_list = pvr.get_objects()
    if not objects_list:
        log.error("Aborting due to failure to retrieve %s shows list", type)
        if notifications:
            callback_notify(
                {'event': 'error', 'reason': 'Failure to retrieve %s shows list' % type})
        exit()
    objects_type = 'movies' if type.lower() == 'radarr' else 'shows'
    log.info("Retrieved %s %s list, %s found: %d", type,
             objects_type, objects_type, len(objects_list))
    return objects_list


############################################################
# SHOWS
############################################################

@app.command(help='Add a single show to Sonarr.')
@click.option('--show_id', '-id', help='Trakt show_id.', required=True)
@click.option('--folder', '-f', default=None, help='Add show with this root folder to Sonarr.')
@click.option('--no-search', is_flag=True, help='Disable search when adding show to Sonarr.')
def show(show_id, folder=None, no_search=False):
    from media.sonarr import Sonarr
    from media.trakt import Trakt
    from helpers import sonarr as sonarr_helper

    # replace sonarr root_folder if folder is supplied
    if folder:
        cfg['sonarr']['root_folder'] = folder

    trakt = Trakt(cfg)
    sonarr = Sonarr(cfg.sonarr.url, cfg.sonarr.api_key)

    validate_trakt(trakt, False)
    validate_pvr(sonarr, 'Sonarr', False)

    profile_id = get_profile_id(sonarr, cfg.sonarr.profile)
    profile_tags = get_profile_tags(sonarr)

    # get trakt show
    trakt_show = trakt.get_show(show_id)

    if not trakt_show:
        log.error("Aborting due to failure to retrieve Trakt show")
        return None
    else:
        log.info("Retrieved Trakt show information for %s: %s (%d)", show_id, trakt_show['title'],
                 trakt_show['year'])

    # determine which tags to use when adding this series
    use_tags = sonarr_helper.series_tag_id_from_network(
        profile_tags, cfg.sonarr.tags, trakt_show['network'])

    # add show to sonarr
    if sonarr.add_series(trakt_show['ids']['tvdb'], trakt_show['title'], trakt_show['ids']['slug'], profile_id,
                         cfg.sonarr.root_folder, use_tags, not no_search):
        log.info("ADDED %s (%d) with tags: %s", trakt_show['title'], trakt_show['year'],
                 sonarr_helper.readable_tag_from_ids(profile_tags, use_tags))
    else:
        log.error("FAILED adding %s (%d) with tags: %s", trakt_show['title'], trakt_show['year'],
                  sonarr_helper.readable_tag_from_ids(profile_tags, use_tags))

    return


@app.command(help='Add multiple shows to Sonarr.')
@click.option('--list-type', '-t',
              help='Trakt list to process. For example, anticipated, trending, popular, person, watched, played, '
                   'recommended, watchlist or any URL to a list', required=True)
@click.option('--add-limit', '-l', default=0, help='Limit number of shows added to Sonarr.', show_default=True)
@click.option('--add-delay', '-d', default=2.5, help='Seconds between each add request to Sonarr.', show_default=True)
@click.option('--sort', '-s', default='votes', type=click.Choice(['votes', 'rating', 'release']),
              help='Sort list to process.')
@click.option('--genre', '-g', default=None, help='Only add shows from this genre to Sonarr.')
@click.option('--folder', '-f', default=None, help='Add shows with this root folder to Sonarr.')
@click.option('--actor', '-a', default=None, help='Only add movies from this actor to Radarr.')
@click.option('--no-search', is_flag=True, help='Disable search when adding shows to Sonarr.')
@click.option('--notifications', is_flag=True, help='Send notifications.')
@click.option('--authenticate-user',
              help='Specify which user to authenticate with to retrieve Trakt lists. Default: first user in the config')
@click.option('--ignore-blacklist', is_flag=True, help='Ignores the blacklist when running the command.')
@click.option('--remove-rejected-from-recommended', is_flag=True,
              help='Removes rejected/existing shows from recommended.')
def shows(list_type, add_limit=0, add_delay=2.5, sort='votes', genre=None, folder=None, actor=None, no_search=False,
          notifications=False, authenticate_user=None, ignore_blacklist=False, remove_rejected_from_recommended=False):
    from media.sonarr import Sonarr
    from media.trakt import Trakt
    from helpers import misc as misc_helper
    from helpers import sonarr as sonarr_helper
    from helpers import trakt as trakt_helper

    added_shows = 0

    # remove genre from shows blacklisted_genres if supplied
    if genre:
        misc_helper.unblacklist_genres(
            genre, cfg['filters']['shows']['blacklisted_genres'])

    # replace sonarr root_folder if folder is supplied
    if folder:
        cfg['sonarr']['root_folder'] = folder

    # validate trakt client_id
    trakt = Trakt(cfg)
    sonarr = Sonarr(cfg.sonarr.url, cfg.sonarr.api_key)

    validate_trakt(trakt, notifications)
    validate_pvr(sonarr, 'Sonarr', notifications)

    profile_id = get_profile_id(sonarr, cfg.sonarr.profile)
    profile_tags = get_profile_tags(sonarr)

    pvr_objects_list = get_objects(sonarr, 'Sonarr', notifications)

    # get trakt series list
    if list_type.lower() == 'anticipated':
        trakt_objects_list = trakt.get_anticipated_shows(
            genres=genre, languages=cfg.filters.shows.allowed_languages)
    elif list_type.lower() == 'trending':
        trakt_objects_list = trakt.get_trending_shows(
            genres=genre, languages=cfg.filters.shows.allowed_languages)
    elif list_type.lower() == 'popular':
        trakt_objects_list = trakt.get_popular_shows(
            genres=genre, languages=cfg.filters.shows.allowed_languages)
    elif list_type.lower() == 'person':
        if not actor:
            log.error(
                "You must specify an actor with the --actor / -a parameter when using the person list type!")
            return None
        trakt_objects_list = trakt.get_person_shows(person=actor, genres=genre,
                                                    languages=cfg.filters.shows.allowed_languages)
    elif list_type.lower() == 'recommended':
        trakt_objects_list = trakt.get_recommended_shows(authenticate_user, genres=genre,
                                                         languages=cfg.filters.shows.allowed_languages)
    elif list_type.lower().startswith('played'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_played_shows(genres=genre, languages=cfg.filters.shows.allowed_languages,
                                                         most_type=most_type if most_type else None)
    elif list_type.lower().startswith('watched'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_watched_shows(genres=genre, languages=cfg.filters.shows.allowed_languages,
                                                          most_type=most_type if most_type else None)
    elif list_type.lower() == 'watchlist':
        trakt_objects_list = trakt.get_watchlist_shows(authenticate_user)
    else:
        trakt_objects_list = trakt.get_user_list_shows(
            list_type, authenticate_user)

    if not trakt_objects_list:
        log.error(
            "Aborting due to failure to retrieve Trakt %s shows list", list_type)
        if notifications:
            callback_notify(
                {'event': 'abort', 'type': 'shows', 'list_type': list_type,
                 'reason': 'Failure to retrieve Trakt %s shows list' % list_type})
        return None
    else:
        log.info("Retrieved Trakt %s shows list, shows found: %d",
                 list_type, len(trakt_objects_list))

    # set remove_rejected_recommended to False if this is not the recommended list
    if list_type.lower() != 'recommended':
        remove_rejected_from_recommended = False

    # build filtered series list without series that exist in sonarr
    processed_series_list = sonarr_helper.remove_existing_series(pvr_objects_list, trakt_objects_list,
                                                                 callback_remove_recommended
                                                                 if remove_rejected_from_recommended else None)
    if processed_series_list is None:
        log.error(
            "Aborting due to failure to remove existing Sonarr shows from retrieved Trakt shows list")
        if notifications:
            callback_notify({'event': 'abort', 'type': 'shows', 'list_type': list_type,
                             'reason': 'Failure to remove existing Sonarr shows from retrieved Trakt %s shows list'
                                       % list_type})
        return None
    else:
        log.info("Removed existing Sonarr shows from Trakt shows list, shows left to process: %d",
                 len(processed_series_list))

    # sort filtered series list
    if sort == 'release':
        sorted_series_list = misc_helper.sorted_list(
            processed_series_list, 'show', 'first_aired')
        log.info("Sorted shows list to process by release date")
    elif sort == 'rating':
        sorted_series_list = misc_helper.sorted_list(
            processed_series_list, 'show', 'rating')
        log.info("Sorted shows list to process by highest rating")
    else:
        sorted_series_list = misc_helper.sorted_list(
            processed_series_list, 'show', 'votes')
        log.info("Sorted shows list to process by highest votes")

    # loop series_list
    log.info("Processing list now...")
    for series in sorted_series_list:
        try:
            # check if genre matches genre supplied via argument
            if genre and not misc_helper.allowed_genres(genre, 'show', series):
                log.debug("Skipping: %s because it was not from %s genre(s)",
                          series['show']['title'], genre.lower())
                continue

            # check if series passes out blacklist criteria inspection
            if not trakt_helper.is_show_blacklisted(series, cfg.filters.shows, ignore_blacklist,
                                                    callback_remove_recommended
                                                    if remove_rejected_from_recommended else None):
                log.info("Adding: %s | Genres: %s | Network: %s | Country: %s", series['show']['title'],
                         ', '.join(series['show']['genres']
                                   ), series['show']['network'],
                         series['show']['country'].upper())

                # determine which tags to use when adding this series
                use_tags = sonarr_helper.series_tag_id_from_network(profile_tags, cfg.sonarr.tags,
                                                                    series['show']['network'])
                # add show to sonarr
                if sonarr.add_series(series['show']['ids']['tvdb'], series['show']['title'],
                                     series['show']['ids']['slug'], profile_id, cfg.sonarr.root_folder, use_tags,
                                     not no_search):
                    log.info("ADDED %s (%d) with tags: %s", series['show']['title'], series['show']['year'],
                             sonarr_helper.readable_tag_from_ids(profile_tags, use_tags))
                    if notifications:
                        callback_notify(
                            {'event': 'add_show', 'list_type': list_type, 'show': series['show']})
                    added_shows += 1
                else:
                    log.error("FAILED adding %s (%d) with tags: %s", series['show']['title'], series['show']['year'],
                              sonarr_helper.readable_tag_from_ids(profile_tags, use_tags))

                # stop adding shows, if added_shows >= add_limit
                if add_limit and added_shows >= add_limit:
                    break

                # sleep before adding any more
                time.sleep(add_delay)

        except Exception:
            log.exception("Exception while processing show %s: ",
                          series['show']['title'])

    log.info("Added %d new show(s) to Sonarr", added_shows)

    # send notification
    if notifications:
        notify.send(message="Added %d shows from Trakt's %s list" %
                    (added_shows, list_type))

    return added_shows


############################################################
# MOVIES
############################################################

@app.command(help='Add a single movie to Radarr.')
@click.option('--movie_id', '-id', help='Trakt movie_id.', required=True)
@click.option('--folder', '-f', default=None, help='Add movie with this root folder to Radarr.')
@click.option('--no-search', is_flag=True, help='Disable search when adding movie to Radarr.')
def movie(movie_id, folder=None, no_search=False):
    from media.radarr import Radarr
    from media.trakt import Trakt

    # replace radarr root_folder if folder is supplied
    if folder:
        cfg['radarr']['root_folder'] = folder

    # validate trakt api_key
    trakt = Trakt(cfg)
    radarr = Radarr(cfg.radarr.url, cfg.radarr.api_key)

    validate_trakt(trakt, False)
    validate_pvr(radarr, 'Radarr', False)

    profile_id = get_profile_id(radarr, cfg.radarr.profile)

    # get trakt movie
    trakt_movie = trakt.get_movie(movie_id)

    if not trakt_movie:
        log.error("Aborting due to failure to retrieve Trakt movie")
        return None
    else:
        log.info("Retrieved Trakt movie information for %s: %s (%d)", movie_id, trakt_movie['title'],
                 trakt_movie['year'])

    # add movie to radarr
    if radarr.add_movie(trakt_movie['ids']['tmdb'], trakt_movie['title'], trakt_movie['year'],
                        trakt_movie['ids']['slug'], profile_id, cfg.radarr.root_folder, not no_search):
        log.info("ADDED %s (%d)", trakt_movie['title'], trakt_movie['year'])
    else:
        log.error("FAILED adding %s (%d)",
                  trakt_movie['title'], trakt_movie['year'])

    return


@app.command(help='Add multiple movies to Radarr.')
@click.option('--list-type', '-t',
              help='Trakt list to process. For example, anticipated, trending, popular, boxoffice, person, watched, '
                   'recommended, played, watchlist or any URL to a list', required=True)
@click.option('--add-limit', '-l', default=0, help='Limit number of movies added to Radarr.', show_default=True)
@click.option('--add-delay', '-d', default=2.5, help='Seconds between each add request to Radarr.', show_default=True)
@click.option('--sort', '-s', default='votes', type=click.Choice(['votes', 'rating', 'release']),
              help='Sort list to process.')
@click.option('--rating', '-r', default=None, type=(int), help='Set a minimum rating threshold (according to Rotten Tomatoes)')
@click.option('--genre', '-g', default=None, help='Only add movies from this genre to Radarr.')
@click.option('--folder', '-f', default=None, help='Add movies with this root folder to Radarr.')
@click.option('--actor', '-a', default=None, help='Only add movies from this actor to Radarr.')
@click.option('--no-search', is_flag=True, help='Disable search when adding movies to Radarr.')
@click.option('--notifications', is_flag=True, help='Send notifications.')
@click.option('--authenticate-user',
              help='Specify which user to authenticate with to retrieve Trakt lists. Default: first user in the config.')
@click.option('--ignore-blacklist', is_flag=True, help='Ignores the blacklist when running the command.')
@click.option('--remove-rejected-from-recommended', is_flag=True,
              help='Removes rejected/existing movies from recommended.')
def movies(list_type, add_limit=0, add_delay=2.5, sort='votes', rating=None, genre=None, folder=None, actor=None, no_search=False,
           notifications=False, authenticate_user=None, ignore_blacklist=False, remove_rejected_from_recommended=False):
    from media.radarr import Radarr
    from media.trakt import Trakt
    from helpers import misc as misc_helper
    from helpers import radarr as radarr_helper
    from helpers import trakt as trakt_helper
    from helpers import rating as rating_helper

    added_movies = 0

    # remove genre from movies blacklisted_genres if supplied
    if genre:
        misc_helper.unblacklist_genres(
            genre, cfg['filters']['movies']['blacklisted_genres'])

    # replace radarr root_folder if folder is supplied
    if folder:
        cfg['radarr']['root_folder'] = folder

    # validate trakt api_key
    trakt = Trakt(cfg)
    radarr = Radarr(cfg.radarr.url, cfg.radarr.api_key)

    validate_trakt(trakt, notifications)
    validate_pvr(radarr, 'Radarr', notifications)

    profile_id = get_profile_id(radarr, cfg.radarr.profile)

    pvr_objects_list = get_objects(radarr, 'Radarr', notifications)

    # get trakt movies list
    if list_type.lower() == 'anticipated':
        trakt_objects_list = trakt.get_anticipated_movies(
            genres=genre, languages=cfg.filters.movies.allowed_languages)
    elif list_type.lower() == 'trending':
        trakt_objects_list = trakt.get_trending_movies(
            genres=genre, languages=cfg.filters.movies.allowed_languages)
    elif list_type.lower() == 'popular':
        trakt_objects_list = trakt.get_popular_movies(
            genres=genre, languages=cfg.filters.movies.allowed_languages)
    elif list_type.lower() == 'boxoffice':
        trakt_objects_list = trakt.get_boxoffice_movies()
    elif list_type.lower() == 'person':
        if not actor:
            log.error(
                "You must specify an actor with the --actor / -a parameter when using the person list type!")
            return None
        trakt_objects_list = trakt.get_person_movies(person=actor, genres=genre,
                                                     languages=cfg.filters.movies.allowed_languages)

    elif list_type.lower() == 'recommended':
        trakt_objects_list = trakt.get_recommended_movies(authenticate_user, genres=genre,
                                                          languages=cfg.filters.movies.allowed_languages)
    elif list_type.lower().startswith('played'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_played_movies(genres=genre, languages=cfg.filters.movies.allowed_languages,
                                                          most_type=most_type if most_type else None)
    elif list_type.lower().startswith('watched'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_watched_movies(genres=genre, languages=cfg.filters.movies.allowed_languages,
                                                           most_type=most_type if most_type else None)
    elif list_type.lower() == 'watchlist':
        trakt_objects_list = trakt.get_watchlist_movies(authenticate_user)
    else:
        trakt_objects_list = trakt.get_user_list_movies(
            list_type, authenticate_user)

    if not trakt_objects_list:
        log.error(
            "Aborting due to failure to retrieve Trakt %s movies list", list_type)
        if notifications:
            callback_notify(
                {'event': 'abort', 'type': 'movies', 'list_type': list_type,
                 'reason': 'Failure to retrieve Trakt %s movies list' % list_type})
        return None
    else:
        log.info("Retrieved Trakt %s movies list, movies found: %d",
                 list_type, len(trakt_objects_list))

    # set remove_rejected_recommended to False if this is not the recommended list
    if list_type.lower() != 'recommended':
        remove_rejected_from_recommended = False

    # build filtered movie list without movies that exist in radarr
    processed_movies_list = radarr_helper.remove_existing_movies(pvr_objects_list, trakt_objects_list,
                                                                 callback_remove_recommended
                                                                 if remove_rejected_from_recommended else None)
    if processed_movies_list is None:
        log.error(
            "Aborting due to failure to remove existing Radarr movies from retrieved Trakt movies list")
        if notifications:
            callback_notify({'event': 'abort', 'type': 'movies', 'list_type': list_type,
                             'reason': 'Failure to remove existing Radarr movies from retrieved '
                                       'Trakt %s movies list' % list_type})
        return None
    else:
        log.info("Removed existing Radarr movies from Trakt movies list, movies left to process: %d",
                 len(processed_movies_list))

    # sort filtered movie list
    if sort == 'release':
        sorted_movies_list = misc_helper.sorted_list(
            processed_movies_list, 'movie', 'released')
        log.info("Sorted movies list to process by release date")
    elif sort == 'rating':
        sorted_movies_list = misc_helper.sorted_list(
            processed_movies_list, 'movie', 'rating')
        log.info("Sorted movies list to process by highest rating")
    else:
        sorted_movies_list = misc_helper.sorted_list(
            processed_movies_list, 'movie', 'votes')
        log.info("Sorted movies list to process by highest votes")

    # loop movies
    log.info("Processing list now...")
    for movie in sorted_movies_list:
        try:
            # check if genre matches genre supplied via argument
            if genre and not misc_helper.allowed_genres(genre, 'movie', movie):
                log.debug("Skipping: %s because it was not from %s genre(s)",
                          movie['movie']['title'], genre.lower())
                continue

            # check if movie passes out blacklist criteria inspection
            if not trakt_helper.is_movie_blacklisted(movie, cfg.filters.movies, ignore_blacklist,
                                                     callback_remove_recommended if remove_rejected_from_recommended
                                                     else None):
                # Assuming the movie is not blacklisted, proceed to pull RT score if the user wishes to restrict
                movieRating = None
                if (rating != None and cfg['omdb']['api_key'] != ''):
                    movieRating = rating_helper.get_rating(
                        cfg['omdb']['api_key'], movie)
                    if (movieRating == -1):
                        log.debug("Skipping: %s because it did not have a rating/lacked imdbID",
                                  movie['movie']['title'])
                        continue
                if (rating == None or movieRating >= rating):
                    log.info("Adding: %s (%d) | Genres: %s | Country: %s", movie['movie']['title'], movie['movie']['year'],
                             ', '.join(movie['movie']['genres']), movie['movie']['country'].upper())
                    # add movie to radarr
                    if radarr.add_movie(movie['movie']['ids']['tmdb'], movie['movie']['title'], movie['movie']['year'],
                                        movie['movie']['ids']['slug'], profile_id, cfg.radarr.root_folder, not no_search):
                        log.info(
                            "ADDED %s (%d)", movie['movie']['title'], movie['movie']['year'])
                        if notifications:
                            callback_notify(
                                {'event': 'add_movie', 'list_type': list_type, 'movie': movie['movie']})
                        added_movies += 1
                    else:
                        log.error("FAILED adding %s (%d)",
                                  movie['movie']['title'], movie['movie']['year'])
                else:
                    log.info("SKIPPING: %s (%d) | Genres: %s | Country: %s", movie['movie']['title'],
                             movie['movie']['year'],
                             ', '.join(movie['movie']['genres']), movie['movie']['country'].upper())
                # stop adding movies, if added_movies >= add_limit
                if add_limit and added_movies >= add_limit:
                    break

                # sleep before adding any more
                time.sleep(add_delay)

        except Exception:
            log.exception("Exception while processing movie %s: ",
                          movie['movie']['title'])

    log.info("Added %d new movie(s) to Radarr", added_movies)

    # send notification
    if notifications:
        notify.send(message="Added %d movies from Trakt's %s list" %
                    (added_movies, list_type))

    return added_movies


############################################################
# CALLBACKS
############################################################


def callback_remove_recommended(media_type, media_info):
    from media.trakt import Trakt

    trakt = Trakt(cfg)

    if not media_info[media_type]['title'] or not media_info[media_type]['year']:
        log.debug("Skipping removing %s item from recommended list as no title/year was available:\n%s", media_type,
                  media_info)
        return

    media_name = '%s (%d)' % (
        media_info[media_type]['title'], media_info[media_type]['year'])

    if trakt.remove_recommended_item(media_type, media_info[media_type]['ids']['trakt']):
        log.info("Removed rejected recommended %s: %s", media_type, media_name)
    else:
        log.info("FAILED removing rejected recommended %s: %s",
                 media_type, media_name)


def callback_notify(data):
    log.debug("Received callback data: %s", data)

    # handle event
    if data['event'] == 'add_movie':
        if cfg.notifications.verbose:
            notify.send(
                message="Added %s movie: %s (%d)" % (data['list_type'], data['movie']['title'], data['movie']['year']))
        return
    elif data['event'] == 'add_show':
        if cfg.notifications.verbose:
            notify.send(
                message="Added %s show: %s (%d)" % (data['list_type'], data['show']['title'], data['show']['year']))
        return
    elif data['event'] == 'abort':
        notify.send(message="Aborted adding Trakt %s %s due to: %s" %
                    (data['list_type'], data['type'], data['reason']))
        return
    elif data['event'] == 'error':
        notify.send(message="Error: %s" % data['reason'])
        return
    else:
        log.error("Unexpected callback: %s", data)
    return


############################################################
# AUTOMATIC
############################################################


def automatic_shows(add_delay=2.5, sort='votes', no_search=False, notifications=False, ignore_blacklist=False):
    from media.trakt import Trakt

    total_shows_added = 0
    try:
        log.info("Started")

        for list_type, value in cfg.automatic.shows.items():
            added_shows = None

            if list_type.lower() == 'interval':
                continue

            if list_type.lower() in Trakt.non_user_lists or (
                    '_' in list_type and list_type.lower().partition("_")[0] in Trakt.non_user_lists):
                limit = value

                if limit <= 0:
                    log.info("Skipped Trakt's %s shows list", list_type)
                    continue
                else:
                    log.info("Adding %d shows from Trakt's %s list",
                             limit, list_type)

                local_ignore_blacklist = ignore_blacklist

                if list_type.lower() in cfg.filters.shows.disabled_for:
                    local_ignore_blacklist = True

                # run shows
                added_shows = shows.callback(list_type=list_type, add_limit=limit,
                                             add_delay=add_delay, sort=sort, no_search=no_search,
                                             notifications=notifications, ignore_blacklist=local_ignore_blacklist)
            elif list_type.lower() == 'watchlist':
                for authenticate_user, limit in value.items():
                    if limit <= 0:
                        log.info("Skipped Trakt's %s for %s",
                                 list_type, authenticate_user)
                        continue
                    else:
                        log.info("Adding %d shows from the %s from %s",
                                 limit, list_type, authenticate_user)

                    local_ignore_blacklist = ignore_blacklist

                    if "watchlist:%s".format(authenticate_user) in cfg.filters.shows.disabled_for:
                        local_ignore_blacklist = True

                    # run shows
                    added_shows = shows.callback(list_type=list_type, add_limit=limit,
                                                 add_delay=add_delay, sort=sort, no_search=no_search,
                                                 notifications=notifications, authenticate_user=authenticate_user,
                                                 ignore_blacklist=local_ignore_blacklist)
            elif list_type.lower() == 'lists':
                for list, v in value.items():
                    if isinstance(v, dict):
                        authenticate_user = v['authenticate_user']
                        limit = v['limit']
                    else:
                        authenticate_user = None
                        limit = v

                    local_ignore_blacklist = ignore_blacklist

                    if "list:%s".format(list) in cfg.filters.shows.disabled_for:
                        local_ignore_blacklist = True

                    # run shows
                    added_shows = shows.callback(list_type=list, add_limit=limit,
                                                 add_delay=add_delay, sort=sort, no_search=no_search,
                                                 notifications=notifications, authenticate_user=authenticate_user,
                                                 ignore_blacklist=local_ignore_blacklist)

            if added_shows is None:
                log.error("Failed adding shows from Trakt's %s list", list_type)
                time.sleep(10)
                continue
            total_shows_added += added_shows

            # sleep
            time.sleep(10)

        log.info("Finished, added %d shows total to Sonarr!", total_shows_added)
        # send notification
        if notifications:
            notify.send(message="Added %d shows total to Sonarr!" %
                        total_shows_added)

    except Exception:
        log.exception("Exception while automatically adding shows: ")
    return


def automatic_movies(add_delay=2.5, sort='votes', no_search=False, notifications=False, ignore_blacklist=False, rating_limit=None):
    from media.trakt import Trakt

    total_movies_added = 0
    try:
        log.info("Started")

        for list_type, value in cfg.automatic.movies.items():
            added_movies = None

            if list_type.lower() == 'interval':
                continue

            if list_type.lower() in Trakt.non_user_lists or (
                    '_' in list_type and list_type.lower().partition("_")[0] in Trakt.non_user_lists):
                limit = value

                if limit <= 0:
                    log.info("Skipped Trakt's %s movies list", list_type)
                    continue
                else:
                    log.info("Adding %d movies from Trakt's %s list",
                             limit, list_type)

                local_ignore_blacklist = ignore_blacklist

                if list_type.lower() in cfg.filters.movies.disabled_for:
                    local_ignore_blacklist = True

                # run movies
                added_movies = movies.callback(list_type=list_type, add_limit=limit,
                                               add_delay=add_delay, sort=sort, no_search=no_search,
                                               notifications=notifications, rating=rating_limit)
            elif list_type.lower() == 'watchlist':
                for authenticate_user, limit in value.items():
                    if limit <= 0:
                        log.info("Skipped Trakt's %s for %s",
                                 list_type, authenticate_user)
                        continue
                    else:
                        log.info("Adding %d movies from the %s from %s",
                                 limit, list_type, authenticate_user)

                    local_ignore_blacklist = ignore_blacklist

                    if "watchlist:%s".format(authenticate_user) in cfg.filters.movies.disabled_for:
                        local_ignore_blacklist = True

                    # run movies
                    added_movies = movies.callback(list_type=list_type, add_limit=limit,
                                                   add_delay=add_delay, sort=sort, no_search=no_search,
                                                   notifications=notifications, authenticate_user=authenticate_user,
                                                   ignore_blacklist=local_ignore_blacklist, rating=rating_limit)
            elif list_type.lower() == 'lists':
                for list, v in value.items():
                    if isinstance(v, dict):
                        authenticate_user = v['authenticate_user']
                        limit = v['limit']
                    else:
                        authenticate_user = None
                        limit = v

                    local_ignore_blacklist = ignore_blacklist

                    if "list:%s".format(list) in cfg.filters.movies.disabled_for:
                        local_ignore_blacklist = True

                    # run shows
                    added_movies = movies.callback(list_type=list, add_limit=limit,
                                                   add_delay=add_delay, sort=sort, no_search=no_search,
                                                   notifications=notifications, authenticate_user=authenticate_user,
                                                   ignore_blacklist=local_ignore_blacklist, rating=rating_limit)

            if added_movies is None:
                log.error("Failed adding movies from Trakt's %s list", list_type)
                time.sleep(10)
                continue
            total_movies_added += added_movies

            # sleep
            time.sleep(10)

        log.info("Finished, added %d movies total to Radarr!",
                 total_movies_added)
        # send notification
        if notifications:
            notify.send(message="Added %d movies total to Radarr!" %
                        total_movies_added)

    except Exception:
        log.exception("Exception while automatically adding movies: ")
    return


@app.command(help='Run in automatic mode.')
@click.option('--add-delay', '-d', default=2.5, help='Seconds between each add request to Sonarr / Radarr.',
              show_default=True)
@click.option('--sort', '-s', default='votes', type=click.Choice(['votes', 'rating', 'release']),
              help='Sort list to process.')
@click.option('--no-search', is_flag=True, help='Disable search when adding to Sonarr / Radarr.')
@click.option('--run-now', is_flag=True, help="Do a first run immediately without waiting.")
@click.option('--no-notifications', is_flag=True, help="Disable notifications.")
@click.option('--ignore-blacklist', is_flag=True, help='Ignores the blacklist when running the command.')
def run(add_delay=2.5, sort='votes', no_search=False, run_now=False, no_notifications=False, ignore_blacklist=False):
    log.info("Automatic mode is now running...")

    # Add tasks to schedule and do first run if enabled
    if cfg.automatic.movies.interval:
        movie_schedule = schedule.every(cfg.automatic.movies.interval).hours.do(
            automatic_movies,
            add_delay,
            sort,
            no_search,
            not no_notifications,
            ignore_blacklist,
            int(cfg.filters.movies.rating_limit) if cfg.filters.movies.rating_limit != "" else None
        )
        if run_now:
            movie_schedule.run()

            # Sleep between tasks
            time.sleep(add_delay)

    if cfg.automatic.shows.interval:
        shows_schedule = schedule.every(cfg.automatic.shows.interval).hours.do(
            automatic_shows,
            add_delay,
            sort,
            no_search,
            not no_notifications,
            ignore_blacklist
        )
        if run_now:
            shows_schedule.run()

            # Sleep between tasks
            time.sleep(add_delay)

    # Enter running schedule
    while True:
        try:
            # Sleep until next run
            log.info("Next job at %s", schedule.next_run())
            time.sleep(max(schedule.idle_seconds(), 0))
            # Check jobs to run
            schedule.run_pending()

        except Exception as e:
            log.exception(
                "Unhandled exception occurred while processing scheduled tasks: %s", e)
            time.sleep(1)


############################################################
# MISC
############################################################

def init_notifications():
    try:
        for notification_name, notification_config in cfg.notifications.items():
            if notification_name.lower() == 'verbose':
                continue

            notify.load(**notification_config)
    except Exception:
        log.exception("Exception initializing notification agents: ")
    return


# Handles exit signals, cancels jobs and exits cleanly
def exit_handler(signum, frame):
    log.info("Received %s, canceling jobs and exiting.",
             signal.Signals(signum).name)
    schedule.clear()
    exit()


############################################################
# MAIN
############################################################

if __name__ == "__main__":

    print("")
    print("""PGTrakt Started

""")

    # Register the signal handlers
    signal.signal(signal.SIGTERM, exit_handler)
    signal.signal(signal.SIGINT, exit_handler)

    # Start application
    app()
