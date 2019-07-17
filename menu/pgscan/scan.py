#!/usr/bin/env python2.7
from gdrive import Gdrive
import utils
import plex
import db
import json
import logging
import os
import sys
import time
from copy import copy
from logging.handlers import RotatingFileHandler

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
logFormatter = logging.Formatter(
    '%(asctime)24s - %(levelname)8s - %(name)9s [%(thread)5d]: %(message)s')
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
    maxBytes=1024 * 1024 * 5,
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

google = None


############################################################
# QUEUE PROCESSOR
############################################################


def queue_processor():
    logger.info("Starting queue processor in 10 seconds")
    try:
        time.sleep(10)
        logger.info("Queue processor started")
        db_scan_requests = db.get_all_items()
        items = 0
        for db_item in db_scan_requests:
            thread.start(plex.scan, args=[conf.configs, scan_lock, db_item['scan_path'], db_item['scan_for'],
                                          db_item['scan_section'],
                                          db_item['scan_type'], resleep_paths])
            items += 1
            time.sleep(2)
        logger.info("Restored %d scan requests from database", items)
    except Exception:
        logger.exception(
            "Exception while processing scan requests from database: ")
    return


############################################################
# FUNCS
############################################################


def start_scan(path, scan_for, scan_type):
    section = utils.get_plex_section(conf.configs, path)
    if section <= 0:
        return False
    else:
        logger.debug("Using section id: %d for '%s'", section, path)

    if conf.configs['SERVER_USE_SQLITE']:
        db_exists, db_file = db.exists_file_root_path(path)
        if not db_exists and db.add_item(path, scan_for, section, scan_type):
            logger.info("Added '%s' to database, proceeding with scan", path)
        else:
            logger.info(
                "Already processing '%s' from same folder, aborting adding an extra scan request to the queue", db_file)
            resleep_paths.append(db_file)
            return False

    thread.start(plex.scan, args=[
                 conf.configs, scan_lock, path, scan_for, section, scan_type, resleep_paths])
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

def process_google_changes(changes):
    global google
    file_paths = []

    # convert changes to file paths list
    for change in changes:
        logger.debug("Processing Google change: %s", change)
        if 'file' in change and 'fileId' in change:
            # dont consider trashed/removed events for processing
            if ('trashed' in change['file'] and change['file']['trashed']) or (
                    'removed' in change and change['removed']):
                # remove item from cache
                if google.remove_item_from_cache(change['fileId']):
                    logger.info("Removed '%s' from cache: %s",
                                change['fileId'], change['file']['name'])
                continue

            # we always want to add changes to the cache so renames etc can be reflected inside the cache
            google.add_item_to_cache(change['fileId'], change['file']['name'],
                                     [] if 'parents' not in change['file'] else change['file']['parents'])

            # dont process folder events
            if 'mimeType' in change['file'] and 'vnd.google-apps.folder' in change['file']['mimeType']:
                # ignore this change as we dont want to scan folders
                continue

            # get this files paths
            success, item_paths = google.get_id_file_paths(change['fileId'],
                                                           change['file']['teamDriveId'] if 'teamDriveId' in change[
                                                               'file'] else None)
            if success and len(item_paths):
                file_paths.extend(item_paths)
        elif 'teamDrive' in change and 'teamDriveId' in change:
            # this is a teamdrive change
            # dont consider trashed/removed events for processing
            if 'removed' in change and change['removed']:
                # remove item from cache
                if google.remove_item_from_cache(change['teamDriveId']):
                    logger.info("Removed teamDrive '%s' from cache: %s", change['teamDriveId'],
                                change['teamDrive']['name'] if 'name' in change['teamDrive'] else 'Unknown teamDrive')
                continue

            if 'id' in change['teamDrive'] and 'name' in change['teamDrive']:
                # we always want to add changes to the cache so renames etc can be reflected inside the cache
                google.add_item_to_cache(
                    change['teamDrive']['id'], change['teamDrive']['name'], [])
                continue

    # always dump the cache after running changes
    google.dump_cache()

    # remove files that are not of an allowed extension type
    removed_rejected_extensions = 0
    for file_path in copy(file_paths):
        if not utils.allowed_scan_extension(file_path, conf.configs['GDRIVE']['SCAN_EXTENSIONS']):
            # this file did not have an allowed extension, remove it
            file_paths.remove(file_path)
            removed_rejected_extensions += 1

    if removed_rejected_extensions:
        logger.info("Ignored %d file(s) from Google Drive changes for disallowed file extensions",
                    removed_rejected_extensions)

    # remove files that are in the ignore paths list
    removed_rejected_paths = 0
    for file_path in copy(file_paths):
        for ignore_path in conf.configs['GDRIVE']['IGNORE_PATHS']:
            if file_path.lower().startswith(ignore_path.lower()):
                # this file was from an ignored path, remove it
                file_paths.remove(file_path)
                removed_rejected_paths += 1

    if removed_rejected_paths:
        logger.info("Ignored %d file(s) from Google Drive changes for disallowed file paths",
                    removed_rejected_paths)

    # remove files that already exist in the plex database
    removed_rejected_exists = utils.remove_files_exist_in_plex_database(
        file_paths, conf.configs['PLEX_DATABASE_PATH'])

    if removed_rejected_exists:
        logger.info("Ignored %d file(s) from Google Drive changes for already being in Plex!",
                    removed_rejected_exists)

    # process the file_paths list
    if len(file_paths):
        logger.info("Proceeding with scan of %d file(s) from Google Drive changes: %s", len(
            file_paths), file_paths)

        # loop each file, remapping and starting a scan thread
        for file_path in file_paths:
            final_path = utils.map_pushed_path(conf.configs, file_path)
            start_scan(final_path, 'Google Drive', 'Download')

    return True


def thread_google_monitor():
    global google

    logger.info("Starting Google Drive changes monitor in 30 seconds...")
    time.sleep(30)

    # load access tokens
    google = Gdrive(
        conf.configs, conf.settings['tokenfile'], conf.settings['cachefile'])
    if not google.first_run():
        logger.error("Failed to retrieve Google Drive access tokens...")
        exit(1)
    else:
        logger.info("Google Drive access tokens were successfully loaded")

    try:

        logger.info("Google Drive changes monitor started")
        while True:
            if not google.token['page_token']:
                # we have no page_token, likely this is first run, lets retrieve a starting page token
                if not google.get_changes_first_page_token():
                    logger.error(
                        "Failed to retrieve starting Google Drive changes page token...")
                    return
                else:
                    logger.info(
                        "Retrieved starting Google Drive changes page token: %s", google.token['page_token'])
                    time.sleep(conf.configs['GDRIVE']['POLL_INTERVAL'])

            # get page changes
            changes = []
            changes_attempts = 0

            while True:
                try:
                    success, page = google.get_changes()
                    changes_attempts = 0
                except Exception:
                    changes_attempts += 1
                    logger.exception(
                        "Exception occurred while polling Google Drive for changes on page %s on attempt %d/12: ",
                        str(google.token['page_token']), changes_attempts)

                    if changes_attempts < 12:
                        logger.warning(
                            "Sleeping for 5 minutes before trying to poll Google Drive for changes again...")
                        time.sleep(60 * 5)
                        continue
                    else:
                        logger.error("Failed to poll Google Drive changes after 12 consecutive attempts, "
                                     "aborting...")
                        return

                if not success:
                    logger.error("Failed to retrieve Google Drive changes for page: %s, aborting...",
                                 str(google.token['page_token']))
                    return
                else:
                    # successfully retrieved some changes
                    if 'changes' in page:
                        changes.extend(page['changes'])

                    # page logic
                    if page is not None and 'nextPageToken' in page:
                        # there are more pages to retrieve
                        logger.debug(
                            "There are more Google Drive changes pages to retrieve, retrieving next page...")
                        continue
                    elif page is not None and 'newStartPageToken' in page:
                        # there are no more pages to retrieve
                        break
                    else:
                        logger.error("There was an unexpected outcome when polling Google Drive for changes, "
                                     "aborting future polls...")
                        return

            # process changes
            if len(changes):
                logger.info(
                    "There's %d Google Drive change(s) to process", len(changes))
                process_google_changes(changes)

            # sleep before polling for changes again
            time.sleep(conf.configs['GDRIVE']['POLL_INTERVAL'])

    except Exception:
        logger.exception("Fatal Exception occurred while monitoring Google Drive for changes, page = %s: ",
                         google.token['page_token'])


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
            logger.error("Unknown %s API call from %r",
                         request.method, request.remote_addr)
            return jsonify({'error': 'No cmd parameter was supplied'})
        else:
            logger.info("Client %s API call from %r, type: %s",
                        request.method, request.remote_addr, data['cmd'])

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
        logger.exception("Exception parsing %s API call from %r: ",
                         request.method, request.remote_addr)

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
    logger.debug("Client %r request dump:\n%s", request.remote_addr,
                 json.dumps(data, indent=4, sort_keys=True))

    if ('eventType' in data and data['eventType'] == 'Test') or ('EventType' in data and data['EventType'] == 'Test'):
        logger.info("Client %r made a test request, event: '%s'",
                    request.remote_addr, 'Test')
    elif 'eventType' in data and data['eventType'] == 'Manual':
        logger.info("Client %r made a manual scan request for: '%s'",
                    request.remote_addr, data['filepath'])
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
        final_path = utils.map_pushed_path(
            conf.configs, data['series']['path'])
        start_scan(final_path, 'Sonarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])

    elif 'movie' in data and 'eventType' in data and data['eventType'] == 'Rename' and 'folderPath' in data['movie']:
        # radarr Rename webhook
        logger.info("Client %r scan request for movie: '%s', event: '%s'", request.remote_addr,
                    data['movie']['folderPath'],
                    "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
        final_path = utils.map_pushed_path(
            conf.configs, data['movie']['folderPath'])
        start_scan(final_path, 'Radarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])

    elif 'movie' in data and 'movieFile' in data and 'folderPath' in data['movie'] and \
            'relativePath' in data['movieFile'] and 'eventType' in data:
        # radarr download/upgrade webhook
        path = os.path.join(data['movie']['folderPath'],
                            data['movieFile']['relativePath'])
        logger.info("Client %r scan request for movie: '%s', event: '%s'", request.remote_addr, path,
                    "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
        final_path = utils.map_pushed_path(conf.configs, path)
        start_scan(final_path, 'Radarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])

    elif 'series' in data and 'episodeFile' in data and 'eventType' in data:
        # sonarr download/upgrade webhook
        path = os.path.join(data['series']['path'],
                            data['episodeFile']['relativePath'])
        logger.info("Client %r scan request for series: '%s', event: '%s'", request.remote_addr, path,
                    "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])
        final_path = utils.map_pushed_path(conf.configs, path)
        start_scan(final_path, 'Sonarr',
                   "Upgrade" if ('isUpgrade' in data and data['isUpgrade']) else data['eventType'])

    elif 'artist' in data and 'trackFile' in data and 'eventType' in data:
        # lidarr download/upgrade webhook
        path = os.path.join(data['artist']['path'],
                            data['trackFile']['relativePath'])
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
    logger.info("""
PG Scan Started!
""")
    if conf.args['cmd'] == 'sections':
        plex.show_sections(conf.configs)

        exit(0)
    elif conf.args['cmd'] == 'update_sections':
        plex.updateSectionMappings(conf)
    elif conf.args['cmd'] == 'authorize':
        if not conf.configs['GDRIVE']['ENABLED']:
            logger.error(
                "You must enable the ENABLED setting in the GDRIVE config section...")
            exit(1)
        else:
            google = Gdrive(
                conf.configs, conf.settings['tokenfile'], conf.settings['cachefile'])
            if not google.first_run():
                logger.error("Failed to retrieve access tokens...")
                exit(1)
            else:
                logger.info("Access tokens were successfully retrieved!")
                exit(0)

    elif conf.args['cmd'] == 'server':
        if conf.configs['SERVER_USE_SQLITE']:
            start_queue_reloader()

        if conf.configs['GDRIVE']['ENABLED']:
            if not os.path.exists(conf.settings['tokenfile']):
                logger.error(
                    "You must authorize your Google Drive account with the authorize option...")
                exit(1)
            start_google_monitor()

        logger.info("Starting server: http://%s:%d/%s",
                    conf.configs['SERVER_IP'],
                    conf.configs['SERVER_PORT'],
                    conf.configs['SERVER_PASS']
                    )
        app.run(host=conf.configs['SERVER_IP'],
                port=conf.configs['SERVER_PORT'], debug=False, use_reloader=False)
        logger.info("Server stopped")
        exit(0)
    else:
        logger.error("Unknown command...")
        exit(1)
