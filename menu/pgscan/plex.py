import logging
import os
import sqlite3
import time
from contextlib import closing

import db

try:
    from shlex import quote as cmd_quote
except ImportError:
    from pipes import quote as cmd_quote

import requests
import utils

logger = logging.getLogger("PLEX")


def updateSectionMappings(conf):
    from xml.etree import ElementTree
    try:
        logger.info("Requesting section info from Plex...")
        resp = requests.get('%s/library/sections/all?X-Plex-Token=%s' % (
            conf.configs['PLEX_LOCAL_URL'], conf.configs['PLEX_TOKEN']), timeout=30)
        if(resp.status_code == 200):
            logger.info("Request was successful")
            logger.debug("Request response: %s", resp.text)
            root = ElementTree.fromstring(resp.text)
            output = {}
            for document in root.findall("Directory"):
                output[document.get('key')] = [os.path.join(
                    k.get('path'), '') for k in document.findall("Location")]
            conf.configs['PLEX_SECTION_PATH_MAPPINGS'] = {}
            for k, v in output.items():
                conf.configs['PLEX_SECTION_PATH_MAPPINGS'][k] = v
            conf.save(conf.configs)
    except Exception as e:
        logger.exception(
            "Issue encountered when attemping to dynamically update section mappings")


def scan(config, lock, path, scan_for, section, scan_type, resleep_paths):
    scan_path = ""

    # sleep for delay
    while True:
        if config['SERVER_SCAN_DELAY']:
            logger.info("Scan request from %s for '%s', sleeping for %d seconds...", scan_for, path,
                        config['SERVER_SCAN_DELAY'])
            time.sleep(config['SERVER_SCAN_DELAY'])
        else:
            logger.info("Scan request from %s for '%s'", scan_for, path)

        # check if root scan folder for
        if path in resleep_paths:
            logger.info("Another scan request occurred for folder of '%s', sleeping again!",
                        path)
            utils.remove_item_from_list(path, resleep_paths)
        else:
            break

    # check file exists
    checks = 0
    check_path = utils.map_pushed_path_file_exists(config, path)
    scan_path_is_directory = os.path.isdir(check_path)

    while True:
        checks += 1
        if os.path.exists(check_path):
            logger.info("File '%s' exists on check %d of %d.",
                        check_path, checks, config['SERVER_MAX_FILE_CHECKS'])
            if not scan_path or not len(scan_path):
                scan_path = os.path.dirname(path).strip(
                ) if not scan_path_is_directory else path.strip()
            break
        elif not scan_path_is_directory and config['SERVER_SCAN_FOLDER_ON_FILE_EXISTS_EXHAUSTION'] and \
                config['SERVER_MAX_FILE_CHECKS'] - checks == 1:
            # penultimate check but SERVER_SCAN_FOLDER_ON_FILE_EXISTS_EXHAUSTION was turned on
            # lets make scan path the folder instead for the final check
            logger.warning(
                "File '%s' reached the penultimate file check, changing scan path to '%s', final check commences "
                "in %s seconds", check_path, os.path.dirname(path), config['SERVER_FILE_CHECK_DELAY'])
            check_path = os.path.dirname(check_path).strip()
            scan_path = os.path.dirname(path).strip()
            scan_path_is_directory = os.path.isdir(check_path)
            time.sleep(config['SERVER_FILE_CHECK_DELAY'])
            # send rclone cache clear if enabled
            if config['RCLONE_RC_CACHE_EXPIRE']['ENABLED']:
                utils.rclone_rc_clear_cache(config, check_path)

        elif checks >= config['SERVER_MAX_FILE_CHECKS']:
            logger.warning(
                "File '%s' exhausted all available checks, aborting scan request.", check_path)
            # remove item from database if sqlite is enabled
            if config['SERVER_USE_SQLITE']:
                if db.remove_item(path):
                    logger.info("Removed '%s' from database", path)
                    time.sleep(1)
                else:
                    logger.error("Failed removing '%s' from database", path)
            return

        else:
            logger.info("File '%s' did not exist on check %d of %d, checking again in %s seconds.", check_path,
                        checks,
                        config['SERVER_MAX_FILE_CHECKS'],
                        config['SERVER_FILE_CHECK_DELAY'])
            time.sleep(config['SERVER_FILE_CHECK_DELAY'])
            # send rclone cache clear if enabled
            if config['RCLONE_RC_CACHE_EXPIRE']['ENABLED']:
                utils.rclone_rc_clear_cache(config, check_path)

    # build plex scanner command
    if os.name == 'nt':
        final_cmd = '"%s" --scan --refresh --section %s --directory "%s"' \
                    % (config['PLEX_SCANNER'], str(section), scan_path)
    else:
        cmd = 'export LD_LIBRARY_PATH=' + config['PLEX_LD_LIBRARY_PATH'] + ';'
        if not config['USE_DOCKER']:
            cmd += 'export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=' + \
                config['PLEX_SUPPORT_DIR'] + ';'
        cmd += config['PLEX_SCANNER'] + ' --scan --refresh --section ' + str(section) + ' --directory ' + cmd_quote(
            scan_path)

        if config['USE_DOCKER']:
            final_cmd = 'docker exec -u %s -i %s bash -c %s' % \
                        (cmd_quote(config['PLEX_USER']), cmd_quote(
                            config['DOCKER_NAME']), cmd_quote(cmd))
        elif config['USE_SUDO']:
            final_cmd = 'sudo -u %s bash -c %s' % (
                config['PLEX_USER'], cmd_quote(cmd))
        else:
            final_cmd = cmd

    # invoke plex scanner
    priority = utils.get_priority(config, scan_path)
    logger.debug(
        "Waiting for turn in the scan request backlog with priority: %d", priority)

    lock.acquire(priority)
    try:
        logger.info("Scan request is now being processed")
        # wait for existing scanners being ran by plex
        if config['PLEX_WAIT_FOR_EXTERNAL_SCANNERS']:
            scanner_name = os.path.basename(
                config['PLEX_SCANNER']).replace('\\', '')
            if not utils.wait_running_process(scanner_name):
                logger.warning(
                    "There was a problem waiting for existing '%s' process(s) to finish, aborting scan.", scanner_name)
                # remove item from database if sqlite is enabled
                if config['SERVER_USE_SQLITE']:
                    if db.remove_item(path):
                        logger.info("Removed '%s' from database", path)
                        time.sleep(1)
                    else:
                        logger.error(
                            "Failed removing '%s' from database", path)
                return
            else:
                logger.info("No '%s' processes were found.", scanner_name)

        # run external command before scan if supplied
        if len(config['RUN_COMMAND_BEFORE_SCAN']) > 2:
            logger.info("Running external command: %r",
                        config['RUN_COMMAND_BEFORE_SCAN'])
            utils.run_command(config['RUN_COMMAND_BEFORE_SCAN'])
            logger.info("Finished running external command")

        # begin scan
        logger.info("Starting Plex Scanner")
        logger.debug(final_cmd)
        utils.run_command(final_cmd.encode("utf-8"))
        logger.info("Finished scan!")

        # remove item from database if sqlite is enabled
        if config['SERVER_USE_SQLITE']:
            if db.remove_item(path):
                logger.info("Removed '%s' from database", path)
                time.sleep(1)
                logger.info("There is %d queued items remaining...",
                            db.queued_count())
            else:
                logger.error("Failed removing '%s' from database", path)

        # empty trash if configured
        if config['PLEX_EMPTY_TRASH'] and config['PLEX_TOKEN'] and config['PLEX_EMPTY_TRASH_MAX_FILES']:
            logger.info("Checking deleted item count in 10 seconds...")
            time.sleep(10)

            # check deleted item count, don't proceed if more than this value
            deleted_items = get_deleted_count(config)
            if deleted_items > config['PLEX_EMPTY_TRASH_MAX_FILES']:
                logger.warning("There were %d deleted files, skipping emptying trash for section %s", deleted_items,
                               section)
            elif deleted_items == -1:
                logger.error(
                    "Could not determine deleted item count, aborting emptying trash")
            elif not config['PLEX_EMPTY_TRASH_ZERO_DELETED'] and not deleted_items and scan_type != 'Upgrade':
                logger.info(
                    "Skipping emptying trash as there were no deleted items")
            else:
                logger.info(
                    "Emptying trash to clear %d deleted items", deleted_items)
                empty_trash(config, str(section))

        # analyze movie/episode
        if config['PLEX_ANALYZE_TYPE'].lower() != 'off' and not scan_path_is_directory:
            logger.debug("Sleeping 10 seconds before sending analyze request")
            time.sleep(10)
            analyze_item(config, path)

        # run external command after scan if supplied
        if len(config['RUN_COMMAND_AFTER_SCAN']) > 2:
            logger.info("Running external command: %r",
                        config['RUN_COMMAND_AFTER_SCAN'])
            utils.run_command(config['RUN_COMMAND_AFTER_SCAN'])
            logger.info("Finished running external command")

    except Exception:
        logger.exception(
            "Unexpected exception occurred while processing: '%s'", scan_path)
    finally:
        lock.release()
    return


def show_sections(config):
    if os.name == 'nt':
        final_cmd = '""%s" --list"' % config['PLEX_SCANNER']
    else:
        cmd = 'export LD_LIBRARY_PATH=' + config['PLEX_LD_LIBRARY_PATH'] + ';'
        if not config['USE_DOCKER']:
            cmd += 'export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=' + \
                config['PLEX_SUPPORT_DIR'] + ';'
        cmd += config['PLEX_SCANNER'] + ' --list'

        if config['USE_DOCKER']:
            final_cmd = 'docker exec -u %s -it %s bash -c %s' % (
                cmd_quote(config['PLEX_USER']), cmd_quote(config['DOCKER_NAME']), cmd_quote(cmd))
        elif config['USE_SUDO']:
            final_cmd = 'sudo -u %s bash -c "%s"' % (config['PLEX_USER'], cmd)
        else:
            final_cmd = cmd
    logger.info("Using Plex Scanner")
    logger.debug(final_cmd)
    os.system(final_cmd)


def analyze_item(config, scan_path):
    if not os.path.exists(config['PLEX_DATABASE_PATH']):
        logger.info(
            "Could not analyze '%s' because plex database could not be found?", scan_path)
        return
    # get files metadata_item_id
    metadata_item_ids = get_file_metadata_ids(config, scan_path)
    if metadata_item_ids is None or not len(metadata_item_ids):
        logger.info(
            "Aborting analyze of '%s' because could not find any metadata_item_id for it", scan_path)
        return
    metadata_item_id = ','.join(str(x) for x in metadata_item_ids)

    # build plex analyze command
    analyze_type = 'analyze-deeply' if config['PLEX_ANALYZE_TYPE'].lower(
    ) == 'deep' else 'analyze'
    if os.name == 'nt':
        final_cmd = '"%s" --%s --item %s' % (
            config['PLEX_SCANNER'], analyze_type, metadata_item_id)
    else:
        cmd = 'export LD_LIBRARY_PATH=' + config['PLEX_LD_LIBRARY_PATH'] + ';'
        if not config['USE_DOCKER']:
            cmd += 'export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=' + \
                config['PLEX_SUPPORT_DIR'] + ';'
        cmd += config['PLEX_SCANNER'] + ' --' + \
            analyze_type + ' --item ' + metadata_item_id

        if config['USE_DOCKER']:
            final_cmd = 'docker exec -u %s -i %s bash -c %s' % \
                        (cmd_quote(config['PLEX_USER']), cmd_quote(
                            config['DOCKER_NAME']), cmd_quote(cmd))
        elif config['USE_SUDO']:
            final_cmd = 'sudo -u %s bash -c %s' % (
                config['PLEX_USER'], cmd_quote(cmd))
        else:
            final_cmd = cmd

    # begin analysis
    logger.info("Starting %s analysis of metadata_item(s): %s",
                'deep' if config['PLEX_ANALYZE_TYPE'].lower() == 'deep' else 'basic', metadata_item_id)
    logger.debug(final_cmd)
    utils.run_command(final_cmd.encode("utf-8"))
    logger.info("Finished %s analysis of metadata_item(s): %s!",
                'deep' if config['PLEX_ANALYZE_TYPE'].lower() == 'deep' else 'basic', metadata_item_id)


def get_file_metadata_ids(config, file_path):
    results = []
    media_item_row = None

    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            conn.row_factory = sqlite3.Row
            with closing(conn.cursor()) as c:
                # query media_parts to retrieve media_item_row for this file
                for x in range(5):
                    media_item_row = c.execute(
                        "SELECT * FROM media_parts WHERE file=?", (file_path,)).fetchone()
                    if media_item_row:
                        logger.info(
                            "Found row in media_parts where file = '%s' after %d/5 tries!", file_path, x + 1)
                        break
                    else:
                        logger.error("Could not locate record in media_parts where file = '%s', %d/5 attempts...",
                                     file_path, x + 1)
                        time.sleep(10)

                if not media_item_row:
                    logger.error(
                        "Could not locate record in media_parts where file = '%s' after 5 tries...", file_path)
                    return None

                media_item_id = media_item_row['media_item_id']
                if media_item_id and int(media_item_id):
                    # query db to find metadata_item_id
                    metadata_item_id = \
                        c.execute("SELECT * FROM media_items WHERE id=?", (int(media_item_id),)).fetchone()[
                            'metadata_item_id']
                    if metadata_item_id and int(metadata_item_id):
                        logger.debug("Found metadata_item_id for '%s': %d",
                                     file_path, int(metadata_item_id))

                        # query db to find parent_id of metadata_item_id
                        if config['PLEX_ANALYZE_DIRECTORY']:
                            parent_id = \
                                c.execute("SELECT * FROM metadata_items WHERE id=?",
                                          (int(metadata_item_id),)).fetchone()['parent_id']
                            if not parent_id or not int(parent_id):
                                # could not find parent_id of this item, likely its a movie...
                                # lets just return the metadata_item_id
                                return [int(metadata_item_id)]
                            logger.debug(
                                "Found parent_id for '%s': %d", file_path, int(parent_id))

                            # if mode is basic, single parent_id is enough
                            if config['PLEX_ANALYZE_TYPE'].lower() == 'basic':
                                return [int(parent_id)]

                            # lets find all metadata_item_id's with this parent_id for use with deep analyze
                            metadata_items = c.execute("SELECT * FROM metadata_items WHERE parent_id=?",
                                                       (int(parent_id),)).fetchall()
                            if not metadata_items:
                                # could not find any results, lets just return metadata_item_id
                                return [int(metadata_item_id)]

                            for row in metadata_items:
                                if row['id'] and int(row['id']) and int(row['id']) not in results:
                                    results.append(int(row['id']))

                            logger.debug(
                                "Found media_item_id's for '%s': %s", file_path, results)
                            logger.info("Found %d media_item_id's to deep analyze for: '%s'", len(
                                results), file_path)
                        else:
                            # user had PLEX_ANALYZE_DIRECTORY as False - lets just scan the single metadata_item_id
                            results.append(int(metadata_item_id))

    except Exception as ex:
        logger.exception(
            "Exception finding metadata_item_id for '%s': ", file_path)
    return results


def empty_trash(config, section):
    for control in config['PLEX_EMPTY_TRASH_CONTROL_FILES']:
        if not os.path.exists(control):
            logger.info(
                "Skipping emptying trash as control file does not exist: '%s'", control)
            return

    if len(config['PLEX_EMPTY_TRASH_CONTROL_FILES']):
        logger.info("Control file(s) exist!")

    for x in range(5):
        try:
            resp = requests.put('%s/library/sections/%s/emptyTrash?X-Plex-Token=%s' % (
                config['PLEX_LOCAL_URL'], section, config['PLEX_TOKEN']), data=None, timeout=30)
            if resp.status_code == 200:
                logger.info(
                    "Trash cleared for section %s after %d/5 tries!", section, x + 1)
                break
            else:
                logger.error("Unexpected response status_code for empty trash request: %d, %d/5 attempts...",
                             resp.status_code, x + 1)
                time.sleep(10)
        except Exception as ex:
            logger.exception(
                "Exception sending empty trash for section %s, %d/5 attempts: ", section, x + 1)
            time.sleep(10)
    return


def get_deleted_count(config):
    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            with closing(conn.cursor()) as c:
                deleted_metadata = \
                    c.execute(
                        'SELECT count(*) FROM metadata_items WHERE deleted_at IS NOT NULL').fetchone()[0]
                deleted_media_parts = \
                    c.execute(
                        'SELECT count(*) FROM media_parts WHERE deleted_at IS NOT NULL').fetchone()[0]

        return int(deleted_metadata) + int(deleted_media_parts)

    except Exception as ex:
        logger.exception(
            "Exception retrieving deleted item count from database: ")
    return -1
