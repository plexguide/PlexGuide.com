#!/usr/bin/env python3
import os.path
import signal
import sys
import time
import re

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
@click.version_option('1.2.5', prog_name='Traktarr')
@click.option(
    '--config',
    envvar='TRAKTARR_CONFIG',
    type=click.Path(file_okay=True, dir_okay=False),
    help='Configuration file',
    show_default=True,
    default=os.path.join(os.path.dirname(os.path.realpath(sys.argv[0])), "config.json")
)
@click.option(
    '--cachefile',
    envvar='TRAKTARR_CACHEFILE',
    type=click.Path(file_okay=True, dir_okay=False),
    help='Cache file',
    show_default=True,
    default=os.path.join(os.path.dirname(os.path.realpath(sys.argv[0])), "cache.db")
)
@click.option(
    '--logfile',
    envvar='TRAKTARR_LOGFILE',
    type=click.Path(file_okay=True, dir_okay=False),
    help='Log file',
    show_default=True,
    default=os.path.join(os.path.dirname(os.path.realpath(sys.argv[0])), "activity.log")
)
def app(config, cachefile, logfile):
    # Setup global variables
    global cfg, log, notify

    # Load config
    from misc.config import Config
    cfg = Config(configfile=config, cachefile=cachefile, logfile=logfile).cfg

    # Legacy Support
    if cfg.filters.movies.blacklist_title_keywords:
        cfg['filters']['movies']['blacklisted_title_keywords'] = cfg['filters']['movies']['blacklist_title_keywords']
    if cfg.filters.movies.rating_limit:
        cfg['filters']['movies']['rotten_tomatoes'] = cfg['filters']['movies']['rating_limit']
    if cfg.radarr.profile:
        cfg['radarr']['quality'] = cfg['radarr']['profile']
    if cfg.sonarr.profile:
        cfg['sonarr']['quality'] = cfg['sonarr']['profile']

    # Load logger
    from misc.log import logger
    log = logger.get_logger('Traktarr')

    # Load notifications
    from notifications import Notifications
    notify = Notifications()

    # Notifications
    init_notifications()


############################################################
# Trakt OAuth
############################################################

@app.command(help='Authenticate Traktarr.')
def trakt_authentication():
    from media.trakt import Trakt
    trakt = Trakt(cfg)

    if trakt.oauth_authentication():
        log.info("Authentication information saved. Please restart the application.")
        exit()


def validate_trakt(trakt, notifications):
    log.info("Validating Trakt API Key...")
    if not trakt.validate_client_id():
        log.error("Aborting due to failure to validate Trakt API Key")
        if notifications:
            callback_notify({'event': 'error', 'reason': 'Failure to validate Trakt API Key'})
        exit()
    else:
        log.info("...Validated Trakt API Key.")


def validate_pvr(pvr, pvr_type, notifications):
    if not pvr.validate_api_key():
        log.error("Aborting due to failure to validate %s URL / API Key", pvr_type)
        if notifications:
            callback_notify({'event': 'error', 'reason': 'Failure to validate %s URL / API Key' % pvr_type})
        return None
    else:
        log.info("Validated %s URL & API Key.", pvr_type)


def get_quality_profile_id(pvr, quality_profile):
    # retrieve profile id for requested quality profile
    quality_profile_id = pvr.get_quality_profile_id(quality_profile)
    if not quality_profile_id or not quality_profile_id > 0:
        log.error("Aborting due to failure to retrieve Quality Profile ID for: %s", quality_profile)
        exit()
    log.info("Retrieved Quality Profile ID for \'%s\': %d", quality_profile, quality_profile_id)
    return quality_profile_id


def get_language_profile_id(pvr, language_profile):
    # retrieve profile id for requested language profile
    language_profile_id = pvr.get_language_profile_id(language_profile)
    if not language_profile_id or not language_profile_id > 0:
        log.error("No Language Profile ID for: %s", language_profile)
    else:
        log.info("Retrieved Language Profile ID for \'%s\': %d", language_profile, language_profile_id)
    return language_profile_id


def get_profile_tags(pvr):
    profile_tags = pvr.get_tags()
    if profile_tags is None:
        log.error("Aborting due to failure to retrieve Tag IDs")
        exit()
    log.info("Retrieved Sonarr Tag IDs: %d", len(profile_tags))
    return profile_tags


def get_objects(pvr, pvr_type, notifications):
    objects_list = pvr.get_objects()
    objects_type = 'movies' if pvr_type.lower() == 'radarr' else 'shows'
    if not objects_list:
        log.error("Aborting due to failure to retrieve %s list from %s", objects_type, pvr_type)
        if notifications:
            callback_notify({'event': 'error', 'reason': 'Failure to retrieve \'%s\' list from %s' % (objects_type,
                                                                                                      pvr_type)})
        exit()
    log.info("Retrieved %s %s list, %s found: %d", pvr_type, objects_type, objects_type, len(objects_list))
    return objects_list


def get_exclusions(pvr, pvr_type, notifications):
    objects_list = pvr.get_exclusions()
    objects_type = 'movie' if pvr_type.lower() == 'radarr' else 'show'
    if not objects_list:
        log.info("No %s exclusions list found from %s", objects_type, pvr_type)
    log.info("Retrieved %s %s list, %s found: %d", pvr_type, objects_type, objects_type, len(objects_list))
    return objects_list


############################################################
# SHOWS
############################################################

@app.command(help='Add a single show to Sonarr.', context_settings=dict(max_content_width=100))
@click.option(
    '--show-id', '-id',
    help='Trakt Show ID.',
    required=True)
@click.option(
    '--folder', '-f',
    default=None,
    help='Add show with this root folder to Sonarr.')
@click.option(
    '--no-search',
    is_flag=True,
    help='Disable search when adding show to Sonarr.')
def show(
        show_id,
        folder=None,
        no_search=False,
):

    from media.sonarr import Sonarr
    from media.trakt import Trakt
    from helpers import sonarr as sonarr_helper
    from helpers import str as misc_str

    # replace sonarr root_folder if folder is supplied
    if folder:
        cfg['sonarr']['root_folder'] = folder

    trakt = Trakt(cfg)
    sonarr = Sonarr(cfg.sonarr.url, cfg.sonarr.api_key)

    validate_trakt(trakt, False)
    validate_pvr(sonarr, 'Sonarr', False)

    # get trakt show
    trakt_show = trakt.get_show(show_id)

    if not trakt_show:
        log.error("Aborting due to failure to retrieve Trakt show")
        return None

    # set common series variables
    series_title = trakt_show['title']

    # convert series year to string
    if trakt_show['year']:
        series_year = str(trakt_show['year'])
    elif trakt_show['first_aired']:
        series_year = misc_str.get_year_from_timestamp(trakt_show['first_aired'])
    else:
        series_year = '????'

    log.info("Retrieved Trakt show information for \'%s\': \'%s (%s)\'", show_id, series_title, series_year)

    # quality profile id
    quality_profile_id = get_quality_profile_id(sonarr, cfg.sonarr.quality)

    # language profile id
    language_profile_id = get_language_profile_id(sonarr, cfg.sonarr.language)

    # profile tags
    profile_tags = None
    use_tags = None
    readable_tags = None

    if cfg.sonarr.tags:
        profile_tags = get_profile_tags(sonarr)
        # determine which tags to use when adding this series
        use_tags = sonarr_helper.series_tag_id_from_network(profile_tags, cfg.sonarr.tags, trakt_show['network'])
        readable_tags = sonarr_helper.readable_tag_from_ids(profile_tags, use_tags)

    # series type
    if any('anime' in s.lower() for s in trakt_show['genres']):
        series_type = 'anime'
    else:
        series_type = 'standard'

    log.debug("Set series type for \'%s (%s)\' to: %s", series_title, series_year, series_type.title())

    # add show to sonarr
    if sonarr.add_series(
            trakt_show['ids']['tvdb'],
            series_title,
            trakt_show['ids']['slug'],
            quality_profile_id,
            language_profile_id,
            cfg.sonarr.root_folder,
            use_tags,
            not no_search,
            series_type,
    ):

        if profile_tags is not None and readable_tags is not None:
            log.info("ADDED: \'%s (%s)\' with Sonarr Tags: %s", series_title, series_year,
                     readable_tags)
        else:
            log.info("ADDED: \'%s (%s)\'", series_title, series_year)
    else:
        if profile_tags is not None:
            log.error("FAILED ADDING: \'%s (%s)\' with Sonarr Tags: %s", series_title, series_year,
                      readable_tags)
        else:
            log.info("FAILED ADDING: \'%s (%s)\'", series_title, series_year)

    return


@app.command(help='Add multiple shows to Sonarr.', context_settings=dict(max_content_width=100))
@click.option(
    '--list-type', '-t',
    help='Trakt list to process. '
         'For example, \'anticipated\', \'trending\', \'popular\', \'person\', \'watched\', \'played\', '
         '\'recommended\', \'watchlist\', or any URL to a list.',
    required=True)
@click.option(
    '--add-limit', '-l',
    default=0,
    help='Limit number of shows added to Sonarr.')
@click.option(
    '--add-delay', '-d',
    default=2.5,
    help='Seconds between each add request to Sonarr.',
    show_default=True)
@click.option(
    '--sort', '-s',
    default='votes',
    type=click.Choice(['rating', 'release', 'votes']),
    help='Sort list to process.',
    show_default=True)
@click.option(
    '--years', '-y',
    default=None,
    help='Range of years to search. For example, \'2000-2010\'.')
@click.option(
    '--genres', '-g',
    default=None,
    help='Only add shows from this genre to Sonarr. '
         'Multiple genres are specified as a comma-separated list. '
         'Use \'ignore\' to add shows from any genre, including ones with no genre specified.')
@click.option(
    '--folder', '-f',
    default=None,
    help='Add shows with this root folder to Sonarr.')
@click.option(
    '--actor', '-a',
    default=None,
    help='Only add movies from this actor to Radarr. '
         'Only one actor can be specified. '
         'Requires the \'person\' list option.')
@click.option(
    '--include-non-acting-roles',
    is_flag=True,
    help='Include non-acting roles such as \'As Himself\', \'Narrator\', etc. \n'
         'Requires the \'person\' list option with the \'actor\' argument.')
@click.option(
    '--no-search',
    is_flag=True,
    help='Disable search when adding shows to Sonarr.')
@click.option(
    '--notifications',
    is_flag=True,
    help='Send notifications.')
@click.option(
    '--authenticate-user',
    help='Specify which user to authenticate with to retrieve Trakt lists. \n'
         'Defaults to first user in the config')
@click.option(
    '--ignore-blacklist',
    is_flag=True,
    help='Ignores the blacklist when running the command.')
@click.option(
    '--remove-rejected-from-recommended',
    is_flag=True,
    help='Removes rejected/existing shows from recommended.')
def shows(
        list_type,
        add_limit=0,
        add_delay=2.5,
        sort='votes',
        years=None,
        genres=None,
        folder=None,
        actor=None,
        no_search=False,
        include_non_acting_roles=False,
        notifications=False,
        authenticate_user=None,
        ignore_blacklist=False,
        remove_rejected_from_recommended=False,
):

    from media.sonarr import Sonarr
    from media.trakt import Trakt
    from helpers import str as misc_str
    from helpers import misc as misc_helper
    from helpers import sonarr as sonarr_helper
    from helpers import trakt as trakt_helper
    from helpers import tvdb as tvdb_helper

    added_shows = 0

    # process countries
    if not cfg.filters.shows.allowed_countries or 'ignore' in cfg.filters.shows.allowed_countries:
        countries = None
    else:
        countries = cfg.filters.shows.allowed_countries

    # process languages
    if not cfg.filters.shows.allowed_languages or 'ignore' in cfg.filters.shows.allowed_languages:
        languages = None
    else:
        languages = cfg.filters.shows.allowed_languages

    # process genres
    if genres:
        # split comma separated list
        genres = sorted(genres.split(','), key=str.lower)

        # look for special keyword 'ignore'
        if 'ignore' in genres:
            # set special genre keyword to show's blacklisted_genres list
            cfg['filters']['shows']['blacklisted_genres'] = ['ignore']
            genres = None
        else:
            # remove genres from show's blacklisted_genres list
            misc_helper.unblacklist_genres(genres, cfg['filters']['shows']['blacklisted_genres'])
            log.debug("Filter Trakt results with genre(s): %s", ', '.join(map(lambda x: x.title(), genres)))

    # set years range
    r = re.compile('[0-9]{4}-[0-9]{4}')

    if years and r.match(years):
        cfg['filters']['shows']['blacklisted_min_year'] = int(years.split('-')[0])
        cfg['filters']['shows']['blacklisted_max_year'] = int(years.split('-')[1])
    elif cfg.filters.shows.blacklisted_min_year and cfg.filters.shows.blacklisted_max_year:
        years = str(cfg.filters.shows.blacklisted_min_year) + '-' + str(cfg.filters.shows.blacklisted_max_year)
    else:
        years = None

    # runtimes range
    if cfg.filters.shows.blacklisted_min_runtime:
        min_runtime = cfg.filters.shows.blacklisted_min_runtime
    else:
        min_runtime = 0

    if cfg.filters.shows.blacklisted_max_runtime and cfg.filters.shows.blacklisted_max_runtime >= min_runtime:
        max_runtime = cfg.filters.shows.blacklisted_max_runtime
    else:
        max_runtime = 9999

    if min_runtime == 0 and max_runtime == 9999:
        runtimes = None
    else:
        runtimes = str(min_runtime) + '-' + str(max_runtime)

    # replace sonarr root_folder if folder is supplied
    if folder:
        cfg['sonarr']['root_folder'] = folder

    # validate trakt client_id
    trakt = Trakt(cfg)
    sonarr = Sonarr(cfg.sonarr.url, cfg.sonarr.api_key)

    validate_trakt(trakt, notifications)
    validate_pvr(sonarr, 'Sonarr', notifications)

    # quality profile id
    quality_profile_id = get_quality_profile_id(sonarr, cfg.sonarr.quality)

    # language profile id
    language_profile_id = get_language_profile_id(sonarr, cfg.sonarr.language)

    profile_tags = get_profile_tags(sonarr) if cfg.sonarr.tags else None

    pvr_objects_list = get_objects(sonarr, 'Sonarr', notifications)

    # get trakt series list
    if list_type.lower() == 'anticipated':
        trakt_objects_list = trakt.get_anticipated_shows(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower() == 'trending':
        trakt_objects_list = trakt.get_trending_shows(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower() == 'popular':
        trakt_objects_list = trakt.get_popular_shows(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower() == 'person':
        if not actor:
            log.error("You must specify an actor with the \'--actor\' / \'-a\' parameter when using the \'person\'" +
                      " list type!")
            return None
        trakt_objects_list = trakt.get_person_shows(
            years=years,
            person=actor,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
            include_non_acting_roles=include_non_acting_roles,
        )

    elif list_type.lower() == 'recommended':
        trakt_objects_list = trakt.get_recommended_shows(
            authenticate_user,
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower().startswith('played'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_played_shows(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
            most_type=most_type if most_type else None,
        )

    elif list_type.lower().startswith('watched'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_watched_shows(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
            most_type=most_type if most_type else None,
        )

    elif list_type.lower() == 'watchlist':
        trakt_objects_list = trakt.get_watchlist_shows(authenticate_user)
    else:
        trakt_objects_list = trakt.get_user_list_shows(list_type, authenticate_user)

    if not trakt_objects_list:
        log.error("Aborting due to failure to retrieve Trakt \'%s\' shows list.", list_type.capitalize())
        if notifications:
            callback_notify(
                {'event': 'abort', 'type': 'shows', 'list_type': list_type,
                 'reason': 'Failure to retrieve Trakt \'%s\' shows list.' % list_type.capitalize()})
        return None
    else:
        log.info("Retrieved Trakt \'%s\' shows list, shows found: %d", list_type.capitalize(), len(trakt_objects_list))

    # set remove_rejected_recommended to False if this is not the recommended list
    if list_type.lower() != 'recommended':
        remove_rejected_from_recommended = False

    # build filtered series list without series that exist in sonarr
    processed_series_list = sonarr_helper.remove_existing_series(
        pvr_objects_list,
        trakt_objects_list,
        callback_remove_recommended if remove_rejected_from_recommended else None
    )

    if processed_series_list is None:
        log.error("Aborting due to failure to remove existing Sonarr shows from retrieved Trakt shows list.")
        if notifications:
            callback_notify({'event': 'abort', 'type': 'shows', 'list_type': list_type,
                             'reason': 'Failure to remove existing Sonarr shows from retrieved Trakt \'%s\' shows list.'
                                       % list_type.capitalize()})
        return None
    else:
        log.info("Removed existing Sonarr shows from Trakt shows list, shows left to process: %d",
                 len(processed_series_list))

    # sort filtered series list
    if sort == 'release':
        sorted_series_list = misc_helper.sorted_list(processed_series_list, 'show', 'first_aired')
        log.info("Sorted shows list to process by recent 'release' date.")
    elif sort == 'rating':
        sorted_series_list = misc_helper.sorted_list(processed_series_list, 'show', 'rating')
        log.info("Sorted shows list to process by highest 'rating'.")
    else:
        sorted_series_list = misc_helper.sorted_list(processed_series_list, 'show', 'votes')
        log.info("Sorted shows list to process by highest 'votes'.")

    # loop series_list
    log.info("Processing list now...")
    for series in sorted_series_list:
        # noinspection PyBroadException

        # set common series variables
        series_tvdb_id = series['show']['ids']['tvdb']
        series_title = series['show']['title']

        # convert series year to string
        if series['show']['year']:
            series_year = str(series['show']['year'])
        elif series['show']['first_aired']:
            series_year = misc_str.get_year_from_timestamp(series['show']['first_aired'])
        else:
            series_year = '????'

        # series type
        if any('anime' in s.lower() for s in series['show']['genres']):
            series_type = 'anime'
        else:
            series_type = 'standard'

        log.debug("Set series type for \'%s (%s)\' to: %s", series_title, series_year, series_type.title())

        # build list of genres
        series_genres = (', '.join(series['show']['genres'])).title() if series['show']['genres'] else 'N/A'

        try:
            # check if movie has a valid TVDB ID and that it exists on TVDB
            if not tvdb_helper.check_series_tvdb_id(series_title, series_year, series_tvdb_id):
                continue

            # check if genres matches genre(s) supplied via argument
            if genres and not misc_helper.allowed_genres(genres, 'show', series):
                log.debug("SKIPPING: \'%s (%s)\' because it was not from the genre(s): %s", series_title,
                          series_year, ', '.join(map(lambda x: x.title(), genres)))
                continue

            # check if series passes out blacklist criteria inspection
            if not trakt_helper.is_show_blacklisted(
                    series,
                    cfg.filters.shows,
                    ignore_blacklist,
                    callback_remove_recommended if remove_rejected_from_recommended else None,
            ):

                log.info("ADDING: %s (%s) | Country: %s | Language: %s | Genre(s): %s | Network: %s",
                         series_title,
                         series_year,
                         (series['show']['country'] or 'N/A').upper(),
                         (series['show']['language'] or 'N/A').upper(),
                         series_genres,
                         (series['show']['network'] or 'N/A').upper(),
                         )

                # profile tags
                use_tags = None
                readable_tags = None

                if profile_tags is not None:
                    # determine which tags to use when adding this series
                    use_tags = sonarr_helper.series_tag_id_from_network(
                        profile_tags,
                        cfg.sonarr.tags,
                        series['show']['network'],
                    )
                    readable_tags = sonarr_helper.readable_tag_from_ids(
                        profile_tags,
                        use_tags,
                    )

                # add show to sonarr
                if sonarr.add_series(
                        series['show']['ids']['tvdb'],
                        series_title,
                        series['show']['ids']['slug'],
                        quality_profile_id,
                        language_profile_id,
                        cfg.sonarr.root_folder,
                        use_tags,
                        not no_search,
                        series_type,
                ):

                    if profile_tags is not None and readable_tags is not None:
                        log.info("ADDED: \'%s (%s)\' with Sonarr Tags: %s", series_title, series_year,
                                 readable_tags)
                    else:
                        log.info("ADDED: \'%s (%s)\'", series_title, series_year)
                    if notifications:
                        callback_notify({'event': 'add_show', 'list_type': list_type, 'show': series['show']})
                    added_shows += 1
                else:
                    if profile_tags is not None:
                        log.error("FAILED ADDING: \'%s (%s)\' with Sonarr Tags: %s", series_title, series_year,
                                  readable_tags)
                    else:
                        log.info("FAILED ADDING: \'%s (%s)\'", series_title, series_year)
                    continue

            else:
                log.info("SKIPPED: \'%s (%s)\'", series_title, series_year)
                continue

            # stop adding shows, if added_shows >= add_limit
            if add_limit and added_shows >= add_limit:
                break

            # sleep before adding any more
            time.sleep(add_delay)

        except Exception:
            log.exception("Exception while processing show \'%s\': ", series_title)

    log.info("Added %d new show(s) to Sonarr", added_shows)

    # send notification
    if notifications and (cfg.notifications.verbose or added_shows > 0):
        notify.send(message="Added %d shows from Trakt's \'%s\' list" % (added_shows, list_type))

    return added_shows


############################################################
# MOVIES
############################################################

@app.command(help='Add a single movie to Radarr.', context_settings=dict(max_content_width=100))
@click.option(
    '--movie-id', '-id',
    help='Trakt Movie ID.',
    required=True)
@click.option(
    '--folder', '-f',
    default=None,
    help='Add movie with this root folder to Radarr.')
@click.option(
    '--minimum-availability', '-ma',
    type=click.Choice(['announced', 'in_cinemas', 'released', 'predb']),
    help='Add movies with this minimum availability to Radarr. Default is \'released\'.')
@click.option(
    '--no-search',
    is_flag=True,
    help='Disable search when adding movie to Radarr.')
def movie(
        movie_id,
        folder=None,
        minimum_availability=None,
        no_search=False,
):

    from media.radarr import Radarr
    from media.trakt import Trakt

    # replace radarr root_folder if folder is supplied
    if folder:
        cfg['radarr']['root_folder'] = folder
    log.debug('Set root folder to: \'%s\'', cfg['radarr']['root_folder'])

    # replace radarr.minimum_availability if minimum_availability is supplied
    valid_min_avail = ['announced', 'in_cinemas', 'released', 'predb']

    if minimum_availability:
        cfg['radarr']['minimum_availability'] = minimum_availability
    elif cfg['radarr']['minimum_availability'] not in valid_min_avail:
        cfg['radarr']['minimum_availability'] = 'released'

    log.debug('Set minimum availability to: \'%s\'', cfg['radarr']['minimum_availability'])

    # validate trakt api_key
    trakt = Trakt(cfg)
    radarr = Radarr(cfg.radarr.url, cfg.radarr.api_key)

    validate_trakt(trakt, False)
    validate_pvr(radarr, 'Radarr', False)

    # quality profile id
    quality_profile_id = get_quality_profile_id(radarr, cfg.radarr.quality)

    # get trakt movie
    trakt_movie = trakt.get_movie(movie_id)

    if not trakt_movie:
        log.error("Aborting due to failure to retrieve Trakt movie")
        return None

    # convert movie year to string
    movie_year = str(trakt_movie['year']) if trakt_movie['year'] else '????'

    log.info("Retrieved Trakt movie information for \'%s\': \'%s (%s)\'", movie_id, trakt_movie['title'], movie_year)

    # add movie to radarr
    if radarr.add_movie(
            trakt_movie['ids']['tmdb'],
            trakt_movie['title'],
            trakt_movie['year'],
            trakt_movie['ids']['slug'],
            quality_profile_id,
            cfg.radarr.root_folder,
            cfg.radarr.minimum_availability,
            not no_search,
    ):

        log.info("ADDED \'%s (%s)\'", trakt_movie['title'], movie_year)
    else:
        log.error("FAILED ADDING \'%s (%s)\'", trakt_movie['title'], movie_year)

    return


@app.command(help='Add multiple movies to Radarr.', context_settings=dict(max_content_width=100))
@click.option(
    '--list-type', '-t',
    help='Trakt list to process. '
         'For example, \'anticipated\', \'trending\', \'popular\', \'person\', \'watched\', \'played\', '
         '\'recommended\', \'watchlist\', or any URL to a list.',
    required=True)
@click.option(
    '--add-limit', '-l',
    default=0,
    help='Limit number of movies added to Radarr.')
@click.option(
    '--add-delay', '-d',
    default=2.5,
    help='Seconds between each add request to Radarr.',
    show_default=True)
@click.option(
    '--sort', '-s',
    default='votes',
    type=click.Choice(['rating', 'release', 'votes']),
    help='Sort list to process.', show_default=True)
@click.option(
    '--rotten_tomatoes', '-rt',
    default=None,
    type=int,
    help='Set a minimum Rotten Tomatoes score.')
@click.option(
    '--years', '-y',
    default=None,
    help='Range of years to search. For example, \'2000-2010\'.')
@click.option(
    '--genres', '-g',
    default=None,
    help='Only add movies from this genre to Radarr. '
         'Multiple genres are specified as a comma-separated list. '
         'Use \'ignore\' to add movies from any genre, including ones with no genre specified.')
@click.option(
    '--folder', '-f',
    default=None,
    help='Add movies with this root folder to Radarr.')
@click.option(
    '--minimum-availability', '-ma',
    type=click.Choice(['announced', 'in_cinemas', 'released', 'predb']),
    help='Add movies with this minimum availability to Radarr. Default is \'released\'.')
@click.option(
    '--actor', '-a',
    default=None,
    help='Only add movies from this actor to Radarr.'
         'Only one actor can be specified.'
         'Requires the \'person\' list.')
@click.option(
    '--include-non-acting-roles',
    is_flag=True,
    help='Include non-acting roles such as \'As Himself\', \'Narrator\', etc. \n'
         'Requires the \'person\' list option with the \'actor\' argument.')
@click.option(
    '--no-search',
    is_flag=True,
    help='Disable search when adding movies to Radarr.')
@click.option(
    '--notifications',
    is_flag=True,
    help='Send notifications.')
@click.option(
    '--authenticate-user',
    help='Specify which user to authenticate with to retrieve Trakt lists. \n'
         'Defaults to first user in the config.')
@click.option(
    '--ignore-blacklist',
    is_flag=True,
    help='Ignores the blacklist when running the command.')
@click.option(
    '--remove-rejected-from-recommended',
    is_flag=True,
    help='Removes rejected/existing movies from recommended.')
def movies(
        list_type,
        add_limit=0,
        add_delay=2.5,
        sort='votes',
        rotten_tomatoes=None,
        years=None,
        genres=None,
        folder=None,
        minimum_availability=None,
        actor=None,
        include_non_acting_roles=False,
        no_search=False,
        notifications=False,
        authenticate_user=None,
        ignore_blacklist=False,
        remove_rejected_from_recommended=False,
):

    from media.radarr import Radarr
    from media.trakt import Trakt
    from helpers import misc as misc_helper
    from helpers import radarr as radarr_helper
    from helpers import trakt as trakt_helper
    from helpers import omdb as omdb_helper
    from helpers import tmdb as tmdb_helper

    added_movies = 0

    # process countries
    if not cfg.filters.movies.allowed_countries or 'ignore' in cfg.filters.movies.allowed_countries:
        countries = None
    else:
        countries = cfg.filters.movies.allowed_countries

    # process languages
    if not cfg.filters.movies.allowed_languages or 'ignore' in cfg.filters.movies.allowed_languages:
        languages = None
    else:
        languages = cfg.filters.movies.allowed_languages

    # process genres
    if genres:
        # split comma separated list
        genres = sorted(genres.split(','), key=str.lower)

        # look for special keyword 'ignore'
        if 'ignore' in genres:
            # set special keyword 'ignore' to movies's blacklisted_genres list
            cfg['filters']['movies']['blacklisted_genres'] = ['ignore']
            # set genre search parameter to None
            genres = None
        else:
            # remove genre from movies's blacklisted_genres list, if it's there
            misc_helper.unblacklist_genres(genres, cfg['filters']['movies']['blacklisted_genres'])
            log.debug("Filter Trakt results with genre(s): %s", ', '.join(map(lambda x: x.title(), genres)))

    # set years range
    r = re.compile('[0-9]{4}-[0-9]{4}')

    if years and r.match(years):
        cfg['filters']['movies']['blacklisted_min_year'] = int(years.split('-')[0])
        cfg['filters']['movies']['blacklisted_max_year'] = int(years.split('-')[1])
    elif cfg.filters.movies.blacklisted_min_year and cfg.filters.movies.blacklisted_max_year:
        years = str(cfg.filters.movies.blacklisted_min_year) + '-' + str(cfg.filters.movies.blacklisted_max_year)
    else:
        years = None

    # runtimes range
    if cfg.filters.movies.blacklisted_min_runtime:
        min_runtime = cfg.filters.movies.blacklisted_min_runtime
    else:
        min_runtime = 0

    if cfg.filters.movies.blacklisted_max_runtime and cfg.filters.movies.blacklisted_max_runtime >= min_runtime:
        max_runtime = cfg.filters.movies.blacklisted_max_runtime
    else:
        max_runtime = 9999

    if min_runtime == 0 and max_runtime == 9999:
        runtimes = None
    else:
        runtimes = str(min_runtime) + '-' + str(max_runtime)

    # replace radarr root_folder if folder is supplied
    if folder:
        cfg['radarr']['root_folder'] = folder
    log.debug('Set root folder to: \'%s\'', cfg['radarr']['root_folder'])

    # replace radarr.minimum_availability if minimum_availability is supplied
    valid_min_avail = ['announced', 'in_cinemas', 'released', 'predb']

    if minimum_availability:
        cfg['radarr']['minimum_availability'] = minimum_availability
    elif cfg['radarr']['minimum_availability'] not in valid_min_avail:
        cfg['radarr']['minimum_availability'] = 'released'

    log.debug('Set minimum availability to: \'%s\'', cfg['radarr']['minimum_availability'])

    # validate trakt api_key
    trakt = Trakt(cfg)
    radarr = Radarr(cfg.radarr.url, cfg.radarr.api_key)

    validate_trakt(trakt, notifications)
    validate_pvr(radarr, 'Radarr', notifications)

    # quality profile id
    quality_profile_id = get_quality_profile_id(radarr, cfg.radarr.quality)

    pvr_objects_list = get_objects(radarr, 'Radarr', notifications)
    pvr_exclusions_list = get_exclusions(radarr, 'Radarr', notifications)

    # get trakt movies list
    if list_type.lower() == 'anticipated':
        trakt_objects_list = trakt.get_anticipated_movies(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower() == 'trending':
        trakt_objects_list = trakt.get_trending_movies(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower() == 'popular':
        trakt_objects_list = trakt.get_popular_movies(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower() == 'boxoffice':
        trakt_objects_list = trakt.get_boxoffice_movies()

    elif list_type.lower() == 'person':
        if not actor:
            log.error("You must specify an actor with the \'--actor\' / \'-a\' parameter when using the \'person\'" +
                      " list type!")
            return None
        trakt_objects_list = trakt.get_person_movies(
            years=years,
            person=actor,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
            include_non_acting_roles=include_non_acting_roles,
        )

    elif list_type.lower() == 'recommended':
        trakt_objects_list = trakt.get_recommended_movies(
            authenticate_user,
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
        )

    elif list_type.lower().startswith('played'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_played_movies(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
            most_type=most_type if most_type else None,
        )

    elif list_type.lower().startswith('watched'):
        most_type = misc_helper.substring_after(list_type.lower(), "_")
        trakt_objects_list = trakt.get_most_watched_movies(
            years=years,
            countries=countries,
            languages=languages,
            genres=genres,
            runtimes=runtimes,
            most_type=most_type if most_type else None,
        )

    elif list_type.lower() == 'watchlist':
        trakt_objects_list = trakt.get_watchlist_movies(authenticate_user)
    else:
        trakt_objects_list = trakt.get_user_list_movies(list_type, authenticate_user)

    if not trakt_objects_list:
        log.error("Aborting due to failure to retrieve Trakt \'%s\' movies list.", list_type.capitalize())
        if notifications:
            callback_notify(
                {'event': 'abort', 'type': 'movies', 'list_type': list_type,
                 'reason': 'Failure to retrieve Trakt \'%s\' movies list.' % list_type.capitalize()})
        return None
    else:
        log.info("Retrieved Trakt \'%s\' movies list, movies found: %d", list_type.capitalize(),
                 len(trakt_objects_list))

    # set remove_rejected_recommended to False if this is not the recommended list
    if list_type.lower() != 'recommended':
        remove_rejected_from_recommended = False

    # build filtered movie list without movies that exist in radarr
    processed_movies_list, removal_successful = radarr_helper.remove_existing_and_excluded_movies(
        pvr_objects_list,
        pvr_exclusions_list,
        trakt_objects_list,
        callback_remove_recommended if remove_rejected_from_recommended else None)

    if processed_movies_list is None:
        if not removal_successful:
            log.error("Aborting due to failure to remove existing Radarr movies from retrieved Trakt movies list.")
            if notifications:
                callback_notify({'event': 'abort', 'type': 'movies', 'list_type': list_type,
                                 'reason': 'Failure to remove existing Radarr movies from retrieved '
                                           'Trakt \'%s\' movies list.' % list_type.capitalize()})
        else:
            log.info("No more movies left to process in \'%s\' movies list.", list_type.capitalize())
        return None
    else:
        log.info("Removed existing and excluded Radarr movies from Trakt movies list. Movies left to process: %d",
                 len(processed_movies_list))

    # sort filtered movie list
    if sort == 'release':
        sorted_movies_list = misc_helper.sorted_list(processed_movies_list, 'movie', 'released')
        log.info("Sorted movies list to process by recent 'release' date.")
    elif sort == 'rating':
        sorted_movies_list = misc_helper.sorted_list(processed_movies_list, 'movie', 'rating')
        log.info("Sorted movies list to process by highest 'rating'.")
    else:
        sorted_movies_list = misc_helper.sorted_list(processed_movies_list, 'movie', 'votes')
        log.info("Sorted movies list to process by highest 'votes'.")

    # display specified min RT score
    if rotten_tomatoes is not None:
        if cfg.omdb.api_key:
            log.info("Minimum Rotten Tomatoes score of %d%% requested.", rotten_tomatoes)
        else:
            log.info("Skipping minimum Rotten Tomatoes score check as OMDb API Key is missing.")

    # loop movies
    log.info("Processing list now...")
    for sorted_movie in sorted_movies_list:
        # noinspection PyBroadException

        # set common series variables
        movie_title = sorted_movie['movie']['title']
        movie_tmdb_id = sorted_movie['movie']['ids']['tmdb']
        movie_imdb_id = sorted_movie['movie']['ids']['imdb']

        # convert movie year to string
        movie_year = str(sorted_movie['movie']['year']) \
            if sorted_movie['movie']['year'] else '????'

        # build list of genres
        movie_genres = (', '.join(sorted_movie['movie']['genres'])).title() \
            if sorted_movie['movie']['genres'] else 'N/A'

        try:
            # check if movie has a valid TMDb ID and that it exists on TMDb
            if not tmdb_helper.check_movie_tmdb_id(movie_title, movie_year, movie_tmdb_id):
                continue

            # check if genres matches genre(s) supplied via argument
            if genres and not misc_helper.allowed_genres(genres, 'movie', sorted_movie):
                log.debug("SKIPPING: \'%s (%s)\' because it was not from the genre(s): %s", movie_title,
                          movie_year, ', '.join(map(lambda x: x.title(), genres)))
                continue

            # check if movie passes out blacklist criteria inspection
            if not trakt_helper.is_movie_blacklisted(
                    sorted_movie,
                    cfg.filters.movies,
                    ignore_blacklist,
                    callback_remove_recommended if remove_rejected_from_recommended else None,
            ):

                # Skip movie if below user specified min RT score
                if rotten_tomatoes is not None and cfg.omdb.api_key:
                    if not omdb_helper.does_movie_have_min_req_rt_score(
                            cfg.omdb.api_key,
                            movie_title,
                            movie_year,
                            movie_imdb_id,
                            rotten_tomatoes,
                    ):
                        continue

                log.info("ADDING: \'%s (%s)\' | Country: %s | Language: %s | Genre(s): %s ",
                         movie_title,
                         movie_year,
                         (sorted_movie['movie']['country'] or 'N/A').upper(),
                         (sorted_movie['movie']['language'] or 'N/A').upper(),
                         movie_genres,
                         )

                # add movie to radarr
                if radarr.add_movie(
                        sorted_movie['movie']['ids']['tmdb'],
                        movie_title,
                        movie_year,
                        sorted_movie['movie']['ids']['slug'],
                        quality_profile_id,
                        cfg.radarr.root_folder,
                        cfg.radarr.minimum_availability,
                        not no_search,
                ):

                    log.info("ADDED: \'%s (%s)\'", movie_title, movie_year)
                    if notifications:
                        callback_notify({'event': 'add_movie', 'list_type': list_type, 'movie': sorted_movie['movie']})
                    added_movies += 1
                else:
                    log.error("FAILED ADDING: \'%s (%s)\'", movie_title, movie_year)
                    continue
            else:
                log.info("SKIPPED: \'%s (%s)\'", movie_title, movie_year)
                continue

            # stop adding movies, if added_movies >= add_limit
            if add_limit and added_movies >= add_limit:
                break

            # sleep before adding any more
            time.sleep(add_delay)

        except Exception:
            log.exception("Exception while processing movie \'%s\': ", movie_title)

    log.info("Added %d new movie(s) to Radarr", added_movies)

    # send notification
    if notifications and (cfg.notifications.verbose or added_movies > 0):
        notify.send(message="Added %d movie(s) from Trakt's \'%s\' list" % (added_movies, list_type.capitalize()))

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

    # convert media year to string
    media_year = str(media_info[media_type]['year']) if media_info[media_type]['year'] else '????'

    media_name = '\'%s (%s)\'' % (media_info[media_type]['title'], media_year)

    if trakt.remove_recommended_item(media_type, media_info[media_type]['ids']['trakt']):
        log.info("Removed rejected recommended %s: \'%s\'", media_type, media_name)
    else:
        log.info("FAILED removing rejected recommended %s: \'%s\'", media_type, media_name)


def callback_notify(data):
    log.debug("Received callback data: %s", data)

    # handle event
    if data['event'] == 'add_movie':

        # convert movie year to string
        movie_year = str(data['movie']['year']) \
            if data['movie']['year'] else '????'

        if cfg.notifications.verbose:
            notify.send(
                message="Added \'%s\' movie: \'%s (%s)\'" % (data['list_type'].capitalize(), data['movie']['title'],
                                                             movie_year))
        return
    elif data['event'] == 'add_show':

        # convert series year to string
        series_year = str(data['show']['year']) if data['show']['year'] else '????'

        if cfg.notifications.verbose:
            notify.send(
                message="ADDED \'%s\' show: \'%s (%s)\'" % (data['list_type'].capitalize(), data['show']['title'],
                                                            series_year))
        return
    elif data['event'] == 'abort':
        notify.send(message="ABORTED ADDING Trakt \'%s\' %s due to: %s" % (data['list_type'].capitalize(), data['type'],
                                                                           data['reason']))
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


def automatic_shows(
        add_delay=2.5,
        sort='votes',
        no_search=False,
        notifications=False,
        ignore_blacklist=False,
):

    from media.trakt import Trakt

    total_shows_added = 0
    # noinspection PyBroadException
    try:
        log.info("Automatic Shows task started.")

        # send notification
        if notifications and cfg.notifications.verbose:
            notify.send(message="Automatic Shows task started.")

        for list_type, value in cfg.automatic.shows.items():
            added_shows = None

            if list_type.lower() == 'interval':
                continue

            if list_type.lower() in Trakt.non_user_lists or (
                    '_' in list_type and list_type.lower().partition("_")[0] in Trakt.non_user_lists):
                limit = value

                if limit <= 0:
                    log.info("SKIPPED Trakt's \'%s\' shows list.", list_type.capitalize())
                    continue
                else:
                    log.info("ADDING %d show(s) from Trakt's \'%s\' list.", limit, list_type.capitalize())

                local_ignore_blacklist = ignore_blacklist

                if list_type.lower() in cfg.filters.shows.disabled_for:
                    local_ignore_blacklist = True

                # run shows
                added_shows = shows.callback(
                    list_type=list_type,
                    add_limit=limit,
                    add_delay=add_delay,
                    sort=sort,
                    no_search=no_search,
                    notifications=notifications,
                    ignore_blacklist=local_ignore_blacklist,
                )

            elif list_type.lower() == 'watchlist':
                for authenticate_user, limit in value.items():
                    if limit <= 0:
                        log.info("SKIPPED Trakt user \'%s\''s \'%s\'", authenticate_user, list_type.capitalize)
                        continue
                    else:
                        log.info("ADDING %d show(s) from Trakt user \'%s\''s \'%s\'", limit, authenticate_user,
                                 list_type.capitalize)

                    local_ignore_blacklist = ignore_blacklist

                    if "watchlist:%s".format(authenticate_user) in cfg.filters.shows.disabled_for:
                        local_ignore_blacklist = True

                    # run shows
                    added_shows = shows.callback(
                        list_type=list_type,
                        add_limit=limit,
                        add_delay=add_delay,
                        sort=sort,
                        no_search=no_search,
                        notifications=notifications,
                        authenticate_user=authenticate_user,
                        ignore_blacklist=local_ignore_blacklist,
                    )

            elif list_type.lower() == 'lists':

                if len(value.items()) == 0:
                    log.info("SKIPPED Trakt's \'%s\' shows list.", list_type.capitalize())
                    continue

                for list_, v in value.items():
                    if isinstance(v, dict):
                        authenticate_user = v['authenticate_user']
                        limit = v['limit']
                    else:
                        authenticate_user = None
                        limit = v

                    if limit <= 0:
                        log.info("SKIPPED Trakt's \'%s\' shows list.", list_)
                        continue

                    local_ignore_blacklist = ignore_blacklist

                    if "list:%s".format(list_) in cfg.filters.shows.disabled_for:
                        local_ignore_blacklist = True

                    # run shows
                    added_shows = shows.callback(
                        list_type=list_,
                        add_limit=limit,
                        add_delay=add_delay,
                        sort=sort,
                        no_search=no_search,
                        notifications=notifications,
                        authenticate_user=authenticate_user,
                        ignore_blacklist=local_ignore_blacklist,
                    )

            if added_shows is None:
                if not list_type.lower() == 'lists':
                    log.info("FAILED ADDING shows from Trakt's \'%s\' list.", list_type)
                time.sleep(10)
                continue
            total_shows_added += added_shows

            # sleep
            time.sleep(10)

        log.info("FINISHED: Added %d show(s) total to Sonarr!", total_shows_added)
        # send notification
        if notifications and (cfg.notifications.verbose or total_shows_added > 0):
            notify.send(message="Added %d show(s) total to Sonarr!" % total_shows_added)

    except Exception:
        log.exception("Exception while automatically adding shows: ")
    return


def automatic_movies(
        add_delay=2.5,
        sort='votes',
        no_search=False,
        notifications=False,
        ignore_blacklist=False,
        rotten_tomatoes=None,
):

    from media.trakt import Trakt

    total_movies_added = 0
    # noinspection PyBroadException
    try:
        log.info("Automatic Movies task started.")

        # send notification
        if notifications and cfg.notifications.verbose:
            notify.send(message="Automatic Movies task started.")

        for list_type, value in cfg.automatic.movies.items():
            added_movies = None

            if list_type.lower() == 'interval':
                continue

            if list_type.lower() in Trakt.non_user_lists or (
                    '_' in list_type and list_type.lower().partition("_")[0] in Trakt.non_user_lists):
                limit = value

                if limit <= 0:
                    log.info("SKIPPED Trakt's \'%s\' movies list.", list_type.capitalize())
                    continue
                else:
                    log.info("ADDING %d movie(s) from Trakt's \'%s\' list.", limit, list_type.capitalize())

                local_ignore_blacklist = ignore_blacklist

                if list_type.lower() in cfg.filters.movies.disabled_for:
                    local_ignore_blacklist = True

                # run movies
                added_movies = movies.callback(
                    list_type=list_type,
                    add_limit=limit,
                    add_delay=add_delay,
                    sort=sort,
                    no_search=no_search,
                    notifications=notifications,
                    ignore_blacklist=local_ignore_blacklist,
                    rotten_tomatoes=rotten_tomatoes,
                )

            elif list_type.lower() == 'watchlist':
                for authenticate_user, limit in value.items():
                    if limit <= 0:
                        log.info("SKIPPED Trakt user \'%s\''s \'%s\'", authenticate_user, list_type.capitalize)
                        continue
                    else:
                        log.info("ADDING %d movie(s) from Trakt user \'%s\''s \'%s\'", limit,
                                 authenticate_user, list_type.capitalize())

                    local_ignore_blacklist = ignore_blacklist

                    if "watchlist:%s".format(authenticate_user) in cfg.filters.movies.disabled_for:
                        local_ignore_blacklist = True

                    # run movies
                    added_movies = movies.callback(
                        list_type=list_type,
                        add_limit=limit,
                        add_delay=add_delay,
                        sort=sort,
                        no_search=no_search,
                        notifications=notifications,
                        authenticate_user=authenticate_user,
                        ignore_blacklist=local_ignore_blacklist,
                        rotten_tomatoes=rotten_tomatoes,
                    )

            elif list_type.lower() == 'lists':

                if len(value.items()) == 0:
                    log.info("SKIPPED Trakt's \'%s\' movies list", list_type.capitalize())
                    continue

                for list_, v in value.items():
                    if isinstance(v, dict):
                        authenticate_user = v['authenticate_user']
                        limit = v['limit']
                    else:
                        authenticate_user = None
                        limit = v

                    if limit <= 0:
                        log.info("SKIPPED Trakt's \'%s\' movies list.", list_)
                        continue

                    local_ignore_blacklist = ignore_blacklist

                    if "list:%s".format(list_) in cfg.filters.movies.disabled_for:
                        local_ignore_blacklist = True

                    # run shows
                    added_movies = movies.callback(
                        list_type=list_,
                        add_limit=limit,
                        add_delay=add_delay,
                        sort=sort,
                        no_search=no_search,
                        notifications=notifications,
                        authenticate_user=authenticate_user,
                        ignore_blacklist=local_ignore_blacklist,
                        rotten_tomatoes=rotten_tomatoes,
                    )

            if added_movies is None:
                if not list_type.lower() == 'lists':
                    log.info("FAILED ADDING movies from Trakt's \'%s\' list.", list_type.capitalize())
                time.sleep(10)
                continue
            total_movies_added += added_movies

            # sleep
            time.sleep(10)

        log.info("FINISHED: Added %d movie(s) total to Radarr!", total_movies_added)
        # send notification
        if notifications and (cfg.notifications.verbose or total_movies_added > 0):
            notify.send(message="Added %d movie(s) total to Radarr!" % total_movies_added)

    except Exception:
        log.exception("Exception while automatically adding movies: ")
    return


@app.command(help='Run Traktarr in automatic mode.')
@click.option(
    '--add-delay', '-d',
    default=2.5,
    help='Seconds between each add request to Sonarr / Radarr.',
    show_default=True)
@click.option(
    '--sort', '-s',
    default='votes',
    type=click.Choice(['votes', 'rating', 'release']),
    help='Sort list to process.',
    show_default=True)
@click.option(
    '--no-search',
    is_flag=True,
    help='Disable search when adding to Sonarr / Radarr.')
@click.option(
    '--run-now',
    is_flag=True,
    help="Do a first run immediately without waiting.")
@click.option(
    '--no-notifications',
    is_flag=True,
    help="Disable notifications.")
@click.option(
    '--ignore-blacklist',
    is_flag=True,
    help='Ignores the blacklist when running the command.')
def run(
        add_delay=2.5,
        sort='votes',
        no_search=False,
        run_now=False,
        no_notifications=False,
        ignore_blacklist=False,
):

    log.info("Automatic mode is now running.")

    # send notification
    if not no_notifications and cfg.notifications.verbose:
        notify.send(message="Automatic mode is now running.")

    # Add tasks to schedule and do first run if enabled
    if cfg.automatic.movies.interval and cfg.automatic.movies.interval > 0:
        movie_schedule = schedule.every(cfg.automatic.movies.interval).hours.do(
            automatic_movies,
            add_delay,
            sort,
            no_search,
            not no_notifications,
            ignore_blacklist,
            int(cfg.filters.movies.rotten_tomatoes) if cfg.filters.movies.rotten_tomatoes != "" else None,
        )
        if run_now:
            movie_schedule.run()

            # Sleep between tasks
            time.sleep(add_delay)

    if cfg.automatic.shows.interval and cfg.automatic.shows.interval > 0:
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
            log.exception("Unhandled exception occurred while processing scheduled tasks: %s", e)
            time.sleep(1)


############################################################
# MISC
############################################################

def init_notifications():
    # noinspection PyBroadException
    try:
        for notification_name, notification_config in cfg.notifications.items():
            if notification_name.lower() == 'verbose':
                continue

            notify.load(**notification_config)
    except Exception:
        log.exception("Exception initializing notification agents: ")
    return


# Handles exit signals, cancels jobs and exits cleanly
# noinspection PyUnusedLocal
def exit_handler(signum, frame):
    log.info("Received %s, canceling jobs and exiting.", signal.Signals(signum).name)
    schedule.clear()
    exit()


############################################################
# MAIN
############################################################

if __name__ == "__main__":
    print("")

    f = Figlet(font='graffiti')
    print(f.renderText('Traktarr'))

    print("""
Welcome to Traktarr for PG!
""")

    # Register the signal handlers
    signal.signal(signal.SIGTERM, exit_handler)
    signal.signal(signal.SIGINT, exit_handler)

    # Start application
    app()
