#!/usr/bin/env python
# -*- coding: utf-8 -*-
import json
import logging
import os
import sys
import time
from pyfiglet import Figlet
from logging.handlers import RotatingFileHandler

# urllib3
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Replace Python2.X input with raw_input, renamed to input in Python 3
if hasattr(__builtins__, 'raw_input'):
    input = raw_input

from flask import Flask
from flask import abort
from flask import jsonify
from flask import request

# Get config
import config
import threads

############################################################
# INIT
############################################################

# Logging
logFormatter = logging.Formatter('%(asctime)24s - %(levelname)8s - %(name)9s [%(thread)5d]: %(message)s')
rootLogger = logging.getLogger()
rootLogger.setLevel(logging.INFO)

# Decrease modules logging
logging.getLogger('requests').setLevel(logging.ERROR)
logging.getLogger('werkzeug').setLevel(logging.ERROR)
logging.getLogger('peewee').setLevel(logging.ERROR)
logging.getLogger('urllib3.connectionpool').setLevel(logging.ERROR)
logging.getLogger('sqlitedict').setLevel(logging.ERROR)

# Console logger, log to stdout instead of stderr
consoleHandler = logging.StreamHandler(sys.stdout)
consoleHandler.setFormatter(logFormatter)
rootLogger.addHandler(consoleHandler)

# Load initial config
conf = config.Config()

# File logger
fileHandler = RotatingFileHandler(
    conf.settings['logfile'],
    maxBytes=1024 * 1024 * 2,
    backupCount=5,
    encoding='utf-8'
)
fileHandler.setFormatter(logFormatter)
rootLogger.addHandler(fileHandler)

# Set configured log level
rootLogger.setLevel(conf.settings['loglevel'])
# Load config file
conf.load()

# Scan logger
logger = rootLogger.getChild("AUTOSCAN")

# Multiprocessing
thread = threads.Thread()
scan_lock = threads.PriorityLock()
resleep_paths = []

# local imports
import db
import plex
import utils
import rclone
from google import GoogleDrive, GoogleDriveManager

google = None
manager = None


############################################################
# QUEUE PROCESSOR
############################################################


def queue_processor():
    logger.info("Starting queue processor in 10 seconds...")
    try:
        time.sleep(10)
        logger.info("Queue processor started.")
        db_scan_requests = db.get_all_items()
        items = 0
        for db_item in db_scan_requests:
            thread.start(plex.scan, args=[conf.configs, scan_lock, db_item['scan_path'], db_item['scan_for'],
                                          db_item['scan_section'],
                                          db_item['scan_type'], resleep_paths])
            items += 1
            time.sleep(2)
        logger.info("Restored %d scan request(s) from Plex Autoscan database.", items)
    except Exception:
        logger.exception("Exception while processing scan requests from Plex Autoscan database.")
    return


############################################################
# FUNCS
############################################################


def start_scan(path, scan_for, scan_type, scan_title=None, scan_lookup_type=None, scan_lookup_id=None):
    section = utils.get_plex_section(conf.configs, path)
    if section <= 0:
        return False
    else:
        logger.info("Using Section ID '%d' for '%s'", section, path)

    if conf.configs['SERVER_USE_SQLITE']:
        db_exists, db_file = db.exists_file_root_path(path)
        if not db_exists and db.add_item(path, scan_for, section, scan_type):
            logger.info("Added '%s' to Plex Autoscan database.", path)
            logger.info("Proceeding with scan...")
        else:
            logger.info(
                "Already processing '%s' from same folder. Skip adding extra scan request to the queue.", db_file)
            resleep_paths.append(db_file)
            return False

    thread.start(plex.scan,
                 args=[conf.configs, scan_lock, path, scan_for, section, scan_type, resleep_paths, scan_title,
                       scan_lookup_type, scan_lookup_id])
    return True


def start_queue_reloader():
    thread.start(queue_processor)
    return True


def start_google_monitor():
    thread.start(thread_google_monitor)
    return True


############################################################
# GOOGLE DRIVE
############################################################

def process_google_changes(items_added):
    new_file_paths = []

    # process items added
    if not items_added:
        return True

    for file_id, file_paths in items_added.items():
        for file_path in file_paths:
            if file_path in new_file_paths:
                continue
            new_file_paths.append(file_path)

    # remove files that already exist in the plex database
    removed_rejected_exists = utils.remove_files_exist_in_plex_database(conf.configs,
                                                                        new_file_paths)

    if removed_rejected_exists:
        logger.info("Rejected %d file(s) from Google Drive changes for already being in Plex.",
                    removed_rejected_exists)

    # process the file_paths list
    if len(new_file_paths):
        logger.info("Proceeding with scan of %d file(s) from Google Drive changes: %s", len(new_file_paths),
                    new_file_paths)

        # loop each file, remapping and starting a scan thread
        for file_path in new_file_paths:
            final_path = utils.map_pushed_path(conf.configs, file_path)
            start_scan(final_path, 'Google Drive', 'Download')

    return True


def thread_google_monitor():
    global manager

    logger.info("Starting Google Drive monitoring in 30 seconds...")
    time.sleep(30)

    # initialize crypt_decoder to None
    crypt_decoder = None

    # load rclone client if crypt being used
    if conf.configs['RCLONE']['CRYPT_MAPPINGS'] != {}:
        logger.info("Crypt mappings have been defined. Initializing Rclone Crypt Decoder...")
        crypt_decoder = rclone.RcloneDecoder(conf.configs['RCLONE']['BINARY'], conf.configs['RCLONE']['CRYPT_MAPPINGS'],
                                             conf.configs['RCLONE']['CONFIG'])

    # load google drive manager
    manager = GoogleDriveManager(conf.configs['GOOGLE']['CLIENT_ID'], conf.configs['GOOGLE']['CLIENT_SECRET'],
                                 conf.settings['cachefile'], allowed_config=conf.configs['GOOGLE']['ALLOWED'],
                                 show_cache_logs=conf.configs['GOOGLE']['SHOW_CACHE_LOGS'],
                                 crypt_decoder=crypt_decoder, allowed_teamdrives=conf.configs['GOOGLE']['TEAMDRIVES'])

    if not manager.is_authorized():
        logger.error("Failed to validate Google Drive Access Token.")
        exit(1)
    else:
        logger.info("Google Drive access token was successfully validated.")

    # load teamdrives (if enabled)
    if conf.configs['GOOGLE']['TEAMDRIVE'] and not manager.load_teamdrives():
        logger.error("Failed to load Google Teamdrives.")
        exit(1)

    # set callbacks
    manager.set_callbacks({'items_added': process_google_changes})

    try:
        logger.info("Google Drive changes monitor started.")
        while True:
            # poll for changes
            manager.get_changes()
            # sleep before polling for changes again
            time.sleep(conf.configs['GOOGLE']['POLL_INTERVAL'])

    except Exception:
        logger.exception("Fatal Exception occurred while monitoring Google Drive for changes: ")


############################################################
# SERVER
############################################################

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False


@app.route("/api/%s" % conf.configs['SERVER_PASS'], methods=['GET', 'POST'])
def api_call():
    data = {}
    try:
        if request.content_type == 'application/json':
            data = request.get_json(silent=True)
        elif request.method == 'POST':
            data = request.form.to_dict()
        else:
            data = request.args.to_dict()

        # verify cmd was supplied
        if 'cmd' not in data:
            logger.error("Unknown %s API call from %r", request.method, request.remote_addr)
            return jsonify({'error': 'No cmd parameter was supplied'})
        else:
            logger.info("Client %s API call from %r, type: %s", request.method, request.remote_addr, data['cmd'])

        # process cmds
        cmd = data['cmd'].lower()
        if cmd == 'queue_count':
            # queue count
            if not conf.configs['SERVER_USE_SQLITE']:
                # return error if SQLITE db is not enabled
                return jsonify({'error': 'SERVER_USE_SQLITE must be enabled'})
            return jsonify({'queue_count': db.get_queue_count()})

        else:
            # unknown cmd
            return jsonify({'error': 'Unknown cmd: %s' % cmd})

    except Exception:
        logger.exception("Exception parsing %s API call from %r: ", request.method, request.remote_addr)

    return jsonify({'error': 'Unexpected error occurred, check logs...'})


@app.route("/%s" % conf.configs['SERVER_PASS'], methods=['GET'])
def manual_scan():
    if not conf.configs['SERVER_ALLOW_MANUAL_SCAN']:
        return abort(401)
    page = """<!DOCTYPE html>
    <html lang="en">
        <head>
            <title>Plex Autoscan</title>
            <meta charset="utf-8">
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body>
            <div class="container">
                <div class="row justify-content-md-center">
                    <div class="col-md-auto text-center" style="padding-top: 10px;">
                        <h1 style="margin: 10px; margin-bottom: 150px;">Plex Autoscan</h1>

                        <h3 class="text-left" style="margin: 10px;">Path to scan</h3>
                        <form action="" method="post">
                            <div class="input-group mb-3" style="width: 600px;">
                                <input class="form-control" type="text" name="filepath" value="" required="required" placeholder="Path to scan e.g. /mnt/unionfs/Media/Movies/Movie Name (year)/" aria-label="Path to scan e.g. /mnt/unionfs/Media/Movies/Movie Name (year)/" aria-describedby="btn-submit">
                                <div class="input-group-append"><input class="btn btn-outline-secondary primary" type="submit" value="Submit" id="btn-submit"></div>
                                <input type="hidden" name="eventType" value="Manual">
                            </div>
                        </form>
                        <div class="alert alert-info" role="alert">Clicking <b>Submit</b> will add the path to the scan queue.</div>
                    </div>
                </div>
            </div>
        </body>
    </html>"""
    return page, 200


@app.route("/%s" % conf.configs['SERVER_PASS'], methods=['POST'])
def client_pushed():
    if request.content_type == 'application/json':
        data = request.get_json(silent=True)
    else:
        data = request.form.to_dict()

    if not data:
        logger.error("Invalid scan request from: %r", request.remote_addr)
        abort(400)
    logger.debug("Client %r request dump:\n%s", request.remote_addr, json.dumps(data, indent=4, sort_keys=True))

    if ('eventType' in data and data['eventType'] == 'Test') or ('EventType' in data and data['EventType'] == 'Test'):
        logger.info("Client %r made a test request, event: '%s'", request.remote_addr, 'Test')
    elif 'eventType' in data and data['eventType'] == 'Manual':
        logger.info("Client %r made a manual scan request for: '%s'", request.remote_addr, data['filepath'])
        final_path = utils.map_pushed_path(conf.configs, data['filepath'])
        # ignore this request?
        ignore, ignore_match = utils.should_ignore(final_path, conf.configs)
        if ignore:
            logger.info("Ignored scan request for '%s' because '%s' was matched from SERVER_IGNORE_LIST", final_path,
                        ignore_match)
            return "Ignoring scan request because %s was matched from your SERVER_IGNORE_LIST" % ignore_match
        if start_scan(final_path, 'Manual', 'Manual'):
            return """<!DOCTYPE html>
            <html lang="en">
            <head>
                <title>Plex Autoscan</title>
                <meta charset="utf-8">
                <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet">
            </head>
            <body>
                <div class="container">
                    <div class="row justify-content-md-center">
                        <div class="col-md-auto text-center" style="padding-top: 10px;">
                            <h1 style="margin: 10px; margin-bottom: 150px;">Plex Autoscan</h1>
                            <h3 class="text-left" style="margin: 10px;">Success</h3>
                            <div class="alert alert-info" role="alert">
                                <code style="color: #000;">'{0}'</code> was added to scan queue.
                            </div>
                        </div>
                    </div>
                </div>
            </body>
            </html>""".format(final_path)
        else:
            return """<!DOCTYPE html>
            <html lang="en">
            <head>
                <title>Plex Autoscan</title>
                <meta charset="utf-8">
                <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet">
            </head>
            <body>
                <div class="container">
                    <div class="row justify-content-md-center">
                        <div class="col-md-auto text-center" style="padding-top: 10px;">
                            <h1 style="margin: 10px; margin-bottom: 150px;">Plex Autoscan</h1>
                            <h3 class="text-left" style="margin: 10px;">Error</h3>
                            <div class="alert alert-danger" role="alert">
                                <code style="color: #000;">'{0}'</code> has already been added to the scan queue.
                            </div>
                        </div>
                    </div>
                </div>
            </body>
            </html>""".format(data['filepath'])

    elif 'series' in data and 'eventType' in data and data['eventType'] == 'Rename' and 'path' in data['series']:
        # sonarr Rename webhook
        logger.info("Client %r scan request for series: '%s', event: '%s'", request.remote_addr, data['series']['path'],
                    "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
        final_path = utils.map_pushed_path(conf.configs, data['series']['path'])
        start_scan(final_path, 'Sonarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])

    elif 'movie' in data and 'eventType' in data and data['eventType'] == 'Rename' and 'folderPath' in data['movie']:
        # radarr Rename webhook
        logger.info("Client %r scan request for movie: '%s', event: '%s'", request.remote_addr,
                    data['movie']['folderPath'],
                    "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
        final_path = utils.map_pushed_path(conf.configs, data['movie']['folderPath'])
        start_scan(final_path, 'Radarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])

    elif 'movie' in data and 'movieFile' in data and 'folderPath' in data['movie'] and \
            'relativePath' in data['movieFile'] and 'eventType' in data:
        # radarr download/upgrade webhook
        path = os.path.join(data['movie']['folderPath'], data['movieFile']['relativePath'])
        logger.info("Client %r scan request for movie: '%s', event: '%s'", request.remote_addr, path,
                    "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
        final_path = utils.map_pushed_path(conf.configs, path)

        # parse scan inputs
        scan_title = None
        scan_lookup_type = None
        scan_lookup_id = None

        if 'remoteMovie' in data:
            if 'imdbId' in data['remoteMovie'] and data['remoteMovie']['imdbId']:
                # prefer imdb
                scan_lookup_id = data['remoteMovie']['imdbId']
                scan_lookup_type = 'IMDB'
            elif 'tmdbId' in data['remoteMovie'] and data['remoteMovie']['tmdbId']:
                # fallback tmdb
                scan_lookup_id = data['remoteMovie']['tmdbId']
                scan_lookup_type = 'TheMovieDB'

            scan_title = data['remoteMovie']['title'] if 'title' in data['remoteMovie'] and data['remoteMovie'][
                'title'] else None

        # start scan
        start_scan(final_path, 'Radarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'], scan_title,
                   scan_lookup_type, scan_lookup_id)

    elif 'series' in data and 'episodeFile' in data and 'eventType' in data:
        # sonarr download/upgrade webhook
        path = os.path.join(data['series']['path'], data['episodeFile']['relativePath'])
        logger.info("Client %r scan request for series: '%s', event: '%s'", request.remote_addr, path,
                    "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
        final_path = utils.map_pushed_path(conf.configs, path)

        # parse scan inputs
        scan_title = None
        scan_lookup_type = None
        scan_lookup_id = None
        if 'series' in data:
            scan_lookup_id = data['series']['tvdbId'] if 'tvdbId' in data['series'] and data['series'][
                'tvdbId'] else None
            scan_lookup_type = 'TheTVDB' if scan_lookup_id is not None else None
            scan_title = data['series']['title'] if 'title' in data['series'] and data['series'][
                'title'] else None

        # start scan
        start_scan(final_path, 'Sonarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'], scan_title,
                   scan_lookup_type, scan_lookup_id)

    elif 'artist' in data and 'trackFiles' in data and 'eventType' in data:
        # lidarr download/upgrade webhook
        for track in data['trackFiles']:
            if 'path' not in track and 'relativePath' not in track:
                continue

            path = track['path'] if 'path' in track else os.path.join(data['artist']['path'], track['relativePath'])
            logger.info("Client %r scan request for album track: '%s', event: '%s'", request.remote_addr, path,
                        "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
            final_path = utils.map_pushed_path(conf.configs, path)
            start_scan(final_path, 'Lidarr',
                       "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])

    else:
        logger.error("Unknown scan request from: %r", request.remote_addr)
        abort(400)

    return "OK"


############################################################
# MAIN
############################################################

if __name__ == "__main__":
    print("")

    f = Figlet(font='slant', width=100)
    print(f.renderText('Plex Autoscan'))

    logger.info("""
#########################################################################
# Title:    Plex Autoscan                                               #
# Author:   l3uddz                                                      #
# URL:      https://github.com/l3uddz/plex_autoscan                     #
# --                                                                    #
#         Part of the Cloudbox project: https://cloudbox.works          #
#########################################################################
#                   GNU General Public License v3.0                     #
#########################################################################
""")
    if conf.args['cmd'] == 'sections':
        plex.show_sections(conf.configs)
        exit(0)
    elif conf.args['cmd'] == 'sections+':
        plex.show_detailed_sections_info(conf)
        exit(0)
    elif conf.args['cmd'] == 'update_config':
        exit(0)
    elif conf.args['cmd'] == 'authorize':
        if not conf.configs['GOOGLE']['ENABLED']:
            logger.error("You must enable the GOOGLE section in config.")
            exit(1)
        else:
            logger.debug("client_id: %r", conf.configs['GOOGLE']['CLIENT_ID'])
            logger.debug("client_secret: %r", conf.configs['GOOGLE']['CLIENT_SECRET'])

            google = GoogleDrive(conf.configs['GOOGLE']['CLIENT_ID'], conf.configs['GOOGLE']['CLIENT_SECRET'],
                                 conf.settings['cachefile'], allowed_config=conf.configs['GOOGLE']['ALLOWED'])

            # Provide authorization link
            logger.info("Visit the link below and paste the authorization code: ")
            logger.info(google.get_auth_link())
            logger.info("Enter authorization code: ")
            auth_code = input()
            logger.debug("auth_code: %r", auth_code)

            # Exchange authorization code
            token = google.exchange_code(auth_code)
            if not token or 'access_token' not in token:
                logger.error("Failed exchanging authorization code for an Access Token.")
                sys.exit(1)
            else:
                logger.info("Exchanged authorization code for an Access Token:\n\n%s\n", json.dumps(token, indent=2))
            sys.exit(0)

    elif conf.args['cmd'] == 'server':
        if conf.configs['SERVER_USE_SQLITE']:
            start_queue_reloader()

        if conf.configs['GOOGLE']['ENABLED']:
            start_google_monitor()

        logger.info("Starting server: http://%s:%d/%s",
                    conf.configs['SERVER_IP'],
                    conf.configs['SERVER_PORT'],
                    conf.configs['SERVER_PASS']
                    )
        app.run(host=conf.configs['SERVER_IP'], port=conf.configs['SERVER_PORT'], debug=False, use_reloader=False)
        logger.info("Server stopped")
        exit(0)
    elif conf.args['cmd'] == 'build_caches':
        logger.info("Building caches")
        # load google drive manager
        manager = GoogleDriveManager(conf.configs['GOOGLE']['CLIENT_ID'], conf.configs['GOOGLE']['CLIENT_SECRET'],
                                     conf.settings['cachefile'], allowed_config=conf.configs['GOOGLE']['ALLOWED'],
                                     allowed_teamdrives=conf.configs['GOOGLE']['TEAMDRIVES'])

        if not manager.is_authorized():
            logger.error("Failed to validate Google Drive Access Token.")
            exit(1)
        else:
            logger.info("Google Drive Access Token was successfully validated.")

        # load teamdrives (if enabled)
        if conf.configs['GOOGLE']['TEAMDRIVE'] and not manager.load_teamdrives():
            logger.error("Failed to load Google Teamdrives.")
            exit(1)

        # build cache
        manager.build_caches()
        logger.info("Finished building all caches.")
        exit(0)
    else:
        logger.error("Unknown command.")
        exit(1)
