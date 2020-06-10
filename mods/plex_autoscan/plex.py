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


def show_detailed_sections_info(conf):
    from xml.etree import ElementTree
    try:
        logger.info("Requesting section info from Plex...")
        resp = requests.get('%s/library/sections/all?X-Plex-Token=%s' % (
            conf.configs['PLEX_LOCAL_URL'], conf.configs['PLEX_TOKEN']), timeout=30)
        if resp.status_code == 200:
            logger.info("Requesting of section info was successful.")
            logger.debug("Request response: %s", resp.text)
            root = ElementTree.fromstring(resp.text)
            print('')
            print("Plex Sections:")
            print("==============")
            for document in root.findall("Directory"):
                print('')
                print(document.get('key') + ') ' + document.get('title'))
                dashes_length = len(document.get('key') + ') ' + document.get('title'))
                print('-' * dashes_length)
                print("\n".join([os.path.join(k.get('path'), '') for k in document.findall("Location")]))
    except Exception as e:
        logger.exception("Issue encountered when attempting to list detailed sections info.")


def scan(config, lock, path, scan_for, section, scan_type, resleep_paths, scan_title=None, scan_lookup_type=None,
         scan_lookup_id=None):
    scan_path = ""

    # sleep for delay
    while True:
        logger.info("Scan request from %s for '%s'.", scan_for, path)

        if config['SERVER_SCAN_DELAY']:
            logger.info("Sleeping for %d seconds...", config['SERVER_SCAN_DELAY'])
            time.sleep(config['SERVER_SCAN_DELAY'])

        # check if root scan folder for
        if path in resleep_paths:
            logger.info("Another scan request occurred for folder of '%s'.", path)
            logger.info("Sleeping again for %d seconds...", config['SERVER_SCAN_DELAY'])
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
            logger.info("File '%s' exists on check %d of %d.", check_path, checks, config['SERVER_MAX_FILE_CHECKS'])
            if not scan_path or not len(scan_path):
                scan_path = os.path.dirname(path).strip() if not scan_path_is_directory else path.strip()
            break
        elif not scan_path_is_directory and config['SERVER_SCAN_FOLDER_ON_FILE_EXISTS_EXHAUSTION'] and \
                config['SERVER_MAX_FILE_CHECKS'] - checks == 1:
            # penultimate check but SERVER_SCAN_FOLDER_ON_FILE_EXISTS_EXHAUSTION was turned on
            # lets make scan path the folder instead for the final check
            logger.warning(
                "File '%s' reached the penultimate file check. Changing scan path to '%s'. Final check commences "
                "in %s seconds...", check_path, os.path.dirname(path), config['SERVER_FILE_CHECK_DELAY'])
            check_path = os.path.dirname(check_path).strip()
            scan_path = os.path.dirname(path).strip()
            scan_path_is_directory = os.path.isdir(check_path)
            time.sleep(config['SERVER_FILE_CHECK_DELAY'])
            # send Rclone cache clear if enabled
            if config['RCLONE']['RC_CACHE_REFRESH']['ENABLED']:
                utils.rclone_rc_clear_cache(config, check_path)

        elif checks >= config['SERVER_MAX_FILE_CHECKS']:
            logger.warning("File '%s' exhausted all available checks. Aborting scan request.", check_path)
            # remove item from database if sqlite is enabled
            if config['SERVER_USE_SQLITE']:
                if db.remove_item(path):
                    logger.info("Removed '%s' from Plex Autoscan database.", path)
                    time.sleep(1)
                else:
                    logger.error("Failed removing '%s' from Plex Autoscan database.", path)
            return

        else:
            logger.info("File '%s' did not exist on check %d of %d. Checking again in %s seconds...", check_path,
                        checks,
                        config['SERVER_MAX_FILE_CHECKS'],
                        config['SERVER_FILE_CHECK_DELAY'])
            time.sleep(config['SERVER_FILE_CHECK_DELAY'])
            # send Rclone cache clear if enabled
            if config['RCLONE']['RC_CACHE_REFRESH']['ENABLED']:
                utils.rclone_rc_clear_cache(config, check_path)

    # build plex scanner command
    if os.name == 'nt':
        final_cmd = '"%s" --scan --refresh --section %s --directory "%s"' \
                    % (config['PLEX_SCANNER'], str(section), scan_path)
    else:
        cmd = 'export LD_LIBRARY_PATH=' + config['PLEX_LD_LIBRARY_PATH'] + ';'
        if not config['USE_DOCKER']:
            cmd += 'export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=' + config['PLEX_SUPPORT_DIR'] + ';'
        cmd += config['PLEX_SCANNER'] + ' --scan --refresh --section ' + str(section) + ' --directory ' + cmd_quote(
            scan_path)

        if config['USE_DOCKER']:
            final_cmd = 'docker exec -u %s -i %s bash -c %s' % \
                        (cmd_quote(config['PLEX_USER']), cmd_quote(config['DOCKER_NAME']), cmd_quote(cmd))
        elif config['USE_SUDO']:
            final_cmd = 'sudo -u %s bash -c %s' % (config['PLEX_USER'], cmd_quote(cmd))
        else:
            final_cmd = cmd

    # invoke plex scanner
    priority = utils.get_priority(config, scan_path)
    logger.debug("Waiting for turn in the scan request backlog with priority '%d'...", priority)

    lock.acquire(priority)
    try:
        logger.info("Scan request is now being processed...")
        # wait for existing scanners being ran by Plex
        if config['PLEX_WAIT_FOR_EXTERNAL_SCANNERS']:
            if os.name == 'nt':
                scanner_name = os.path.basename(config['PLEX_SCANNER'])
            else:
                scanner_name = os.path.basename(config['PLEX_SCANNER']).replace('\\', '')
            if not utils.wait_running_process(scanner_name, config['USE_DOCKER'], cmd_quote(config['DOCKER_NAME'])):
                logger.warning(
                    "There was a problem waiting for existing '%s' process(s) to finish. Aborting scan.", scanner_name)
                # remove item from database if sqlite is enabled
                if config['SERVER_USE_SQLITE']:
                    if db.remove_item(path):
                        logger.info("Removed '%s' from Plex Autoscan database.", path)
                        time.sleep(1)
                    else:
                        logger.error("Failed removing '%s' from Plex Autoscan database.", path)
                return
            else:
                logger.info("No '%s' processes were found.", scanner_name)

        # run external command before scan if supplied
        if len(config['RUN_COMMAND_BEFORE_SCAN']) > 2:
            logger.info("Running external command: %r", config['RUN_COMMAND_BEFORE_SCAN'])
            utils.run_command(config['RUN_COMMAND_BEFORE_SCAN'])
            logger.info("Finished running external command.")

        # wait for Plex to become responsive (if PLEX_CHECK_BEFORE_SCAN is enabled)
        if 'PLEX_CHECK_BEFORE_SCAN' in config and config['PLEX_CHECK_BEFORE_SCAN']:
            plex_account_user = wait_plex_alive(config)
            if plex_account_user is not None:
                logger.info("Plex is available for media scanning - (Server Account: '%s')", plex_account_user)

        # begin scan
        logger.info("Running Plex Media Scanner for: %s", scan_path)
        logger.debug(final_cmd)
        if os.name == 'nt':
            utils.run_command(final_cmd)
        else:
            utils.run_command(final_cmd.encode("utf-8"))
        logger.info("Finished scan!")

        # remove item from Plex database if sqlite is enabled
        if config['SERVER_USE_SQLITE']:
            if db.remove_item(path):
                logger.debug("Removed '%s' from Plex Autoscan database.", path)
                time.sleep(1)
                logger.info("There are %d queued item(s) remaining.", db.queued_count())
            else:
                logger.error("Failed removing '%s' from Plex Autoscan database.", path)

        # empty trash if configured
        if config['PLEX_EMPTY_TRASH'] and config['PLEX_TOKEN'] and config['PLEX_EMPTY_TRASH_MAX_FILES']:
            logger.debug("Checking deleted items count in 10 seconds...")
            time.sleep(10)

            # check deleted item count, don't proceed if more than this value
            deleted_items = get_deleted_count(config)
            if deleted_items > config['PLEX_EMPTY_TRASH_MAX_FILES']:
                logger.warning("There were %d deleted files. Skip emptying of trash for Section '%s'.", deleted_items,
                               section)
            elif deleted_items == -1:
                logger.error("Could not determine deleted item count. Abort emptying of trash.")
            elif not config['PLEX_EMPTY_TRASH_ZERO_DELETED'] and not deleted_items and scan_type != 'Upgrade':
                logger.debug("Skipping emptying trash as there were no deleted items.")
            else:
                logger.info("Emptying trash to clear %d deleted items...", deleted_items)
                empty_trash(config, str(section))

        # analyze movie/episode
        if config['PLEX_ANALYZE_TYPE'].lower() != 'off' and not scan_path_is_directory:
            logger.debug("Sleeping for 10 seconds...")
            time.sleep(10)
            logger.debug("Sending analysis request...")
            analyze_item(config, path)

        # match item
        if config['PLEX_FIX_MISMATCHED'] and config['PLEX_TOKEN'] and not scan_path_is_directory:
            # were we initiated with the scan_title/scan_lookup_type/scan_lookup_id parameters?
            if scan_title is not None and scan_lookup_type is not None and scan_lookup_id is not None:
                logger.debug("Sleeping for 10 seconds...")
                time.sleep(10)
                logger.debug("Validating match for '%s' (%s ID: %s)...",
                             scan_title,
                             scan_lookup_type, str(scan_lookup_id))
                match_item_parent(config, path, scan_title, scan_lookup_type, scan_lookup_id)

        # run external command after scan if supplied
        if len(config['RUN_COMMAND_AFTER_SCAN']) > 2:
            logger.info("Running external command: %r", config['RUN_COMMAND_AFTER_SCAN'])
            utils.run_command(config['RUN_COMMAND_AFTER_SCAN'])
            logger.info("Finished running external command.")

    except Exception:
        logger.exception("Unexpected exception occurred while processing: '%s'", scan_path)
    finally:
        lock.release()
    return


def show_sections(config):
    if os.name == 'nt':
        final_cmd = '""%s" --list"' % config['PLEX_SCANNER']
    else:
        cmd = 'export LD_LIBRARY_PATH=' + config['PLEX_LD_LIBRARY_PATH'] + ';'
        if not config['USE_DOCKER']:
            cmd += 'export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=' + config['PLEX_SUPPORT_DIR'] + ';'
        cmd += config['PLEX_SCANNER'] + ' --list'

        if config['USE_DOCKER']:
            final_cmd = 'docker exec -u %s -it %s bash -c %s' % (
                cmd_quote(config['PLEX_USER']), cmd_quote(config['DOCKER_NAME']), cmd_quote(cmd))
        elif config['USE_SUDO']:
            final_cmd = 'sudo -u %s bash -c "%s"' % (config['PLEX_USER'], cmd)
        else:
            final_cmd = cmd
    logger.info("Using Plex Scanner")
    print("\n")
    print("Plex Sections:")
    print("==============")
    logger.debug(final_cmd)
    os.system(final_cmd)


def match_item_parent(config, scan_path, scan_title, scan_lookup_type, scan_lookup_id):
    if not os.path.exists(config['PLEX_DATABASE_PATH']):
        logger.info("Could not analyze '%s' because Plex database could not be found.", scan_path)
        return

    # get files metadata_item_id
    metadata_item_id = get_file_metadata_item_id(config, scan_path)
    if metadata_item_id is None:
        logger.error("Aborting match of '%s' as could not find 'metadata_item_id'.", scan_path)
        return

    # find metadata_item_id parent info
    metadata_item_parent_info = get_metadata_parent_info(config, int(metadata_item_id))
    if metadata_item_parent_info is None or 'parent_id' not in metadata_item_parent_info \
            or metadata_item_parent_info['parent_id'] is not None or 'id' not in metadata_item_parent_info \
            or 'title' not in metadata_item_parent_info:
        # parent_id should always be null as we are looking for a series or movie metadata_item_id which has no parent!
        logger.error(
            "Aborting match of '%s' because could not find 'metadata_item_id' of parent for 'metadata_item_id': %d",
            scan_path, int(metadata_item_id))
        return

    parent_metadata_item_id = metadata_item_parent_info['id']
    parent_title = metadata_item_parent_info['title']
    parent_guid = metadata_item_parent_info['guid']
    logger.debug("Found parent 'metadata_item' of '%s': %d = '%s'.", scan_path, int(parent_metadata_item_id),
                 parent_title)

    # did the metadata_item_id have matches already (dupes)?
    scan_directory = os.path.dirname(scan_path)
    metadata_item_id_has_dupes = get_metadata_item_id_has_duplicates(config, metadata_item_id, scan_directory)
    if metadata_item_id_has_dupes:
        # there are multiple media_items with this metadata_item_id who's folder does not match the scan directory
        # we must split the parent metadata_item, wait 10 seconds and then repeat the steps above
        if not split_plex_item(config, parent_metadata_item_id):
            logger.error(
                "Aborting match of '%s' as could not split duplicate 'media_items' with 'metadata_item_id': '%d'",
                scan_path, int(parent_metadata_item_id))
            return

        # reset variables from last lookup
        metadata_item_id = None
        parent_metadata_item_id = None
        parent_title = None
        parent_guid = None

        # sleep before looking up metadata_item_id again
        time.sleep(10)
        metadata_item_id = get_file_metadata_item_id(config, scan_path)
        if metadata_item_id is None:
            logger.error("Aborting match of '%s' as could not find post split 'metadata_item_id'.", scan_path)
            return

        # now lookup parent again
        metadata_item_parent_info = get_metadata_parent_info(config, int(metadata_item_id))
        if metadata_item_parent_info is None or 'parent_id' not in metadata_item_parent_info \
                or metadata_item_parent_info['parent_id'] is not None or 'id' not in metadata_item_parent_info \
                or 'title' not in metadata_item_parent_info:
            # parent_id should always be null as we are looking for a series or movie metadata_item_id
            # which has no parent!
            logger.error(
                "Aborting match of '%s' as could not find post-split 'metadata_item_id' of parent for "
                "'metadata_item_id': %d", scan_path, int(metadata_item_id))
            return

        parent_metadata_item_id = metadata_item_parent_info['id']
        parent_title = metadata_item_parent_info['title']
        parent_guid = metadata_item_parent_info['guid']
        logger.debug("Found parent 'metadata_item' of '%s': %d = '%s'.", scan_path, int(parent_metadata_item_id),
                     parent_title)

    else:
        # there were no duplicate media_items with this metadata_item_id
        logger.info("No duplicate 'media_items' found with 'metadata_item_id': '%d'", int(parent_metadata_item_id))

    # generate new guid
    new_guid = 'com.plexapp.agents.%s://%s?lang=%s' % (scan_lookup_type.lower(), str(scan_lookup_id).lower(),
                                                       config['PLEX_FIX_MISMATCHED_LANG'].lower())
    # does good match?
    if parent_guid and (parent_guid.lower() != new_guid):
        logger.debug("Fixing match for 'metadata_item' '%s' as existing 'GUID' '%s' does not match '%s' ('%s').",
                     parent_title,
                     parent_guid, new_guid, scan_title)
        logger.info("Fixing match of '%s' (%s) to '%s' (%s).", parent_title, parent_guid, scan_title, new_guid)
        # fix item
        match_plex_item(config, parent_metadata_item_id, new_guid, scan_title)
        refresh_plex_item(config, parent_metadata_item_id, scan_title)
    else:
        logger.debug(
            "Skipped match fixing for 'metadata_item' parent '%s' as existing 'GUID' (%s) matches what was "
            "expected (%s).", parent_title, parent_guid, new_guid)
        logger.info("Match validated for '%s' (%s).", parent_title, parent_guid)

    return


def analyze_item(config, scan_path):
    if not os.path.exists(config['PLEX_DATABASE_PATH']):
        logger.warning("Could not analyze of '%s' because Plex database could not be found.", scan_path)
        return
    # get files metadata_item_id
    metadata_item_ids = get_file_metadata_ids(config, scan_path)
    if metadata_item_ids is None or not len(metadata_item_ids):
        logger.warning("Aborting analysis of '%s' because could not find any 'metadata_item_id' for it.", scan_path)
        return
    metadata_item_id = ','.join(str(x) for x in metadata_item_ids)

    # build Plex analyze command
    analyze_type = 'analyze-deeply' if config['PLEX_ANALYZE_TYPE'].lower() == 'deep' else 'analyze'
    if os.name == 'nt':
        final_cmd = '"%s" --%s --item %s' % (config['PLEX_SCANNER'], analyze_type, metadata_item_id)
    else:
        cmd = 'export LD_LIBRARY_PATH=' + config['PLEX_LD_LIBRARY_PATH'] + ';'
        if not config['USE_DOCKER']:
            cmd += 'export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=' + config['PLEX_SUPPORT_DIR'] + ';'
        cmd += config['PLEX_SCANNER'] + ' --' + analyze_type + ' --item ' + metadata_item_id

        if config['USE_DOCKER']:
            final_cmd = 'docker exec -u %s -i %s bash -c %s' % \
                        (cmd_quote(config['PLEX_USER']), cmd_quote(config['DOCKER_NAME']), cmd_quote(cmd))
        elif config['USE_SUDO']:
            final_cmd = 'sudo -u %s bash -c %s' % (config['PLEX_USER'], cmd_quote(cmd))
        else:
            final_cmd = cmd

    # begin analysis
    logger.debug("Starting %s analysis of 'metadata_item': %s",
                 'deep' if config['PLEX_ANALYZE_TYPE'].lower() == 'deep' else 'basic', metadata_item_id)
    logger.debug(final_cmd)
    if os.name == 'nt':
        utils.run_command(final_cmd)
    else:
        utils.run_command(final_cmd.encode("utf-8"))
    logger.info("Finished %s analysis of 'metadata_item': %s",
                'deep' if config['PLEX_ANALYZE_TYPE'].lower() == 'deep' else 'basic', metadata_item_id)


def get_file_metadata_item_id(config, file_path):
    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            conn.row_factory = sqlite3.Row
            with closing(conn.cursor()) as c:
                # query media_parts to retrieve media_item_row for this file
                for x in range(5):
                    media_item_row = c.execute("SELECT * FROM media_parts WHERE file=?", (file_path,)).fetchone()
                    if media_item_row:
                        logger.debug("Found row in 'media_parts' where 'file' = '%s' after %d of 5 tries.", file_path,
                                     x + 1)
                        break
                    else:
                        logger.error(
                            "Could not locate record in 'media_parts' where 'file' = '%s' in %d of 5 attempts...",
                            file_path, x + 1)
                        time.sleep(10)

                if not media_item_row:
                    logger.error("Could not locate record in 'media_parts' where 'file' = '%s' after 5 tries.",
                                 file_path)
                    return None

                media_item_id = media_item_row['media_item_id']
                if media_item_id and int(media_item_id):
                    # query db to find metadata_item_id
                    metadata_item_id = \
                        c.execute("SELECT * FROM media_items WHERE id=?", (int(media_item_id),)).fetchone()[
                            'metadata_item_id']
                    if metadata_item_id and int(metadata_item_id):
                        logger.debug("Found 'metadata_item_id' for '%s': %d", file_path, int(metadata_item_id))
                        return int(metadata_item_id)

    except Exception:
        logger.exception("Exception finding 'metadata_item_id' for '%s': ", file_path)
    return None


def get_metadata_item_id_has_duplicates(config, metadata_item_id, scan_directory):
    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            conn.row_factory = sqlite3.Row
            with closing(conn.cursor()) as c:
                # retrieve matches for metadata_item_id
                metadata_item_id_matches = c.execute('select '
                                                     'count(mi.id) as matches '
                                                     'from media_items mi '
                                                     'join media_parts mp on mp.media_item_id = mi.id '
                                                     'where mi.metadata_item_id=? and mp.file not like ?',
                                                     (metadata_item_id, scan_directory + '%',)).fetchone()
                if metadata_item_id_matches:
                    row_dict = dict(metadata_item_id_matches)
                    if 'matches' in row_dict and row_dict['matches'] >= 1:
                        logger.info(
                            "Found %d 'media_items' with 'metadata_item_id' %d where folder does not match: '%s'",
                            int(row_dict['matches']), int(metadata_item_id), scan_directory)
                        return True
                    else:
                        return False

        logger.error("Failed determining if 'metadata_item_id' '%d' has duplicate 'media_items'.",
                     int(metadata_item_id))
    except Exception:
        logger.exception("Exception determining if 'metadata_item_id' '%d' has duplicate 'media_items': ",
                         int(metadata_item_id))
    return False


def get_metadata_parent_info(config, metadata_item_id):
    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            conn.row_factory = sqlite3.Row
            with closing(conn.cursor()) as c:
                # retrieve parent info for metadata_item_id
                metadata_item_parent_info = c.execute('WITH cte_MediaItems AS ('
                                                      'SELECT '
                                                      'mi.* '
                                                      'FROM metadata_items mi '
                                                      'WHERE mi.id = ? '
                                                      'UNION '
                                                      'SELECT mi.* '
                                                      'FROM cte_MediaItems cte '
                                                      'JOIN metadata_items mi ON mi.id = cte.parent_id'
                                                      ') '
                                                      'SELECT '
                                                      'cte.id'
                                                      ', cte.parent_id'
                                                      ', cte.guid'
                                                      ', cte.title '
                                                      'FROM cte_MediaItems cte '
                                                      'WHERE cte.parent_id IS NULL '
                                                      'LIMIT 1', (metadata_item_id,)).fetchone()
                if metadata_item_parent_info:
                    metadata_item_row = dict(metadata_item_parent_info)
                    if 'parent_id' in metadata_item_row and not metadata_item_row['parent_id']:
                        logger.debug("Found parent row in 'metadata_items' for 'metadata_item_id' '%d': %s",
                                     int(metadata_item_id), metadata_item_row)
                        return metadata_item_row

                logger.error("Failed finding parent row in 'metadata_items' for 'metadata_item_id': %d",
                             int(metadata_item_id))

    except Exception:
        logger.exception("Exception finding parent info for 'metadata_item_id' '%d': ", int(metadata_item_id))
    return None


def get_file_metadata_ids(config, file_path):
    results = []
    media_item_row = None

    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            conn.row_factory = sqlite3.Row
            with closing(conn.cursor()) as c:
                # query media_parts to retrieve media_item_row for this file
                for x in range(5):
                    media_item_row = c.execute("SELECT * FROM media_parts WHERE file=?", (file_path,)).fetchone()
                    if media_item_row:
                        logger.debug("Found row in 'media_parts' where 'file' = '%s' after %d of 5 tries.", file_path,
                                     x + 1)
                        break
                    else:
                        logger.error(
                            "Could not locate record in 'media_parts' where 'file' = '%s' in %d of 5 attempts...",
                            file_path, x + 1)
                        time.sleep(10)

                if not media_item_row:
                    logger.error("Could not locate record in 'media_parts' where 'file' = '%s' after 5 tries",
                                 file_path)
                    return None

                media_item_id = media_item_row['media_item_id']
                if media_item_id and int(media_item_id):
                    # query db to find metadata_item_id
                    metadata_item_id = \
                        c.execute("SELECT * FROM media_items WHERE id=?", (int(media_item_id),)).fetchone()[
                            'metadata_item_id']
                    if metadata_item_id and int(metadata_item_id):
                        logger.debug("Found 'metadata_item_id' for '%s': %d", file_path, int(metadata_item_id))

                        # query db to find parent_id of metadata_item_id
                        if config['PLEX_ANALYZE_DIRECTORY']:
                            parent_id = \
                                c.execute("SELECT * FROM metadata_items WHERE id=?",
                                          (int(metadata_item_id),)).fetchone()['parent_id']
                            if not parent_id or not int(parent_id):
                                # could not find parent_id of this item, likely its a movie...
                                # lets just return the metadata_item_id
                                return [int(metadata_item_id)]
                            logger.debug("Found 'parent_id' for '%s': %d", file_path, int(parent_id))

                            # if mode is basic, single parent_id is enough
                            if config['PLEX_ANALYZE_TYPE'].lower() == 'basic':
                                return [int(parent_id)]

                            # lets find all metadata_item_id's with this parent_id for use with deep analysis
                            metadata_items = c.execute("SELECT * FROM metadata_items WHERE parent_id=?",
                                                       (int(parent_id),)).fetchall()
                            if not metadata_items:
                                # could not find any results, lets just return metadata_item_id
                                return [int(metadata_item_id)]

                            for row in metadata_items:
                                if row['id'] and int(row['id']) and int(row['id']) not in results:
                                    results.append(int(row['id']))

                            logger.debug("Found 'media_item_id' for '%s': %s", file_path, results)
                            logger.info("Found %d 'media_item_id' to deep analyze for: '%s'", len(results), file_path)
                        else:
                            # user had PLEX_ANALYZE_DIRECTORY as False - lets just scan the single metadata_item_id
                            results.append(int(metadata_item_id))

    except Exception as ex:
        logger.exception("Exception finding metadata_item_id for '%s': ", file_path)
    return results


def empty_trash(config, section):
    if len(config['PLEX_EMPTY_TRASH_CONTROL_FILES']):
        logger.info("Control file(s) are specified.")

        for control in config['PLEX_EMPTY_TRASH_CONTROL_FILES']:
            if not os.path.exists(control):
                logger.info("Skip emptying of trash as control file is not present: '%s'", control)
                return

        logger.info("Commence emptying of trash as control file(s) are present.")

    for x in range(5):
        try:
            resp = requests.put('%s/library/sections/%s/emptyTrash?X-Plex-Token=%s' % (
                config['PLEX_LOCAL_URL'], section, config['PLEX_TOKEN']), data=None, timeout=30)
            if resp.status_code == 200:
                logger.info("Trash cleared for Section '%s' after %d of 5 tries.", section, x + 1)
                break
            else:
                logger.error("Unexpected response status_code for empty trash request: %d in %d of 5 attempts...",
                             resp.status_code, x + 1)
                time.sleep(10)
        except Exception as ex:
            logger.exception("Exception sending empty trash for Section '%s' in %d of 5 attempts: ", section, x + 1)
            time.sleep(10)
    return


def wait_plex_alive(config):
    if not config['PLEX_LOCAL_URL'] or not config['PLEX_TOKEN']:
        logger.error(
            "Unable to check if Plex was ready for scan requests because 'PLEX_LOCAL_URL' and/or 'PLEX_TOKEN' are missing in config.")
        return None

    # PLEX_LOCAL_URL and PLEX_TOKEN was provided
    check_attempts = 0
    while True:
        check_attempts += 1
        try:
            resp = requests.get('%s/myplex/account' % (config['PLEX_LOCAL_URL']),
                                headers={'X-Plex-Token': config['PLEX_TOKEN'], 'Accept': 'application/json'},
                                timeout=30, verify=False)
            if resp.status_code == 200 and 'json' in resp.headers['Content-Type']:
                resp_json = resp.json()
                if 'MyPlex' in resp_json:
                    plex_user = resp_json['MyPlex']['username'] if 'username' in resp_json['MyPlex'] else 'Unknown'
                    return plex_user

            logger.error("Unexpected response when checking if Plex was available for scans "
                         "(Attempt: %d): status_code = %d - resp_text =\n%s",
                         check_attempts, resp.status_code, resp.text)
        except Exception:
            logger.exception("Exception checking if Plex was available at %s: ", config['PLEX_LOCAL_URL'])

        logger.warning("Checking again in 15 seconds (attempt %d)...", check_attempts)
        time.sleep(15)
        continue
    return None


def get_deleted_count(config):
    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            with closing(conn.cursor()) as c:
                deleted_metadata = \
                    c.execute('SELECT count(*) FROM metadata_items WHERE deleted_at IS NOT NULL').fetchone()[0]
                deleted_media_parts = \
                    c.execute('SELECT count(*) FROM media_parts WHERE deleted_at IS NOT NULL').fetchone()[0]

        return int(deleted_metadata) + int(deleted_media_parts)

    except Exception as ex:
        logger.exception("Exception retrieving deleted item count from Plex DB: ")
    return -1


def split_plex_item(config, metadata_item_id):
    try:
        url_params = {
            'X-Plex-Token': config['PLEX_TOKEN']
        }
        url_str = '%s/library/metadata/%d/split' % (config['PLEX_LOCAL_URL'], int(metadata_item_id))

        # send options request first (webui does this)
        requests.options(url_str, params=url_params, timeout=30)
        resp = requests.put(url_str, params=url_params, timeout=30)
        if resp.status_code == 200:
            logger.info("Successfully split 'metadata_item_id': '%d'", int(metadata_item_id))
            return True
        else:
            logger.error("Failed splitting 'metadata_item_id': '%d'... Response =\n%s\n", int(metadata_item_id),
                         resp.text)

    except Exception:
        logger.exception("Exception splitting 'metadata_item' %d: ", int(metadata_item_id))
    return False


def match_plex_item(config, metadata_item_id, new_guid, new_name):
    try:
        url_params = {
            'X-Plex-Token': config['PLEX_TOKEN'],
            'guid': new_guid,
            'name': new_name,
        }
        url_str = '%s/library/metadata/%d/match' % (config['PLEX_LOCAL_URL'], int(metadata_item_id))

        requests.options(url_str, params=url_params, timeout=30)
        resp = requests.put(url_str, params=url_params, timeout=30)
        if resp.status_code == 200:
            logger.info("Successfully matched 'metadata_item_id' '%d' to '%s' (%s).", int(metadata_item_id), new_name,
                        new_guid)
            return True
        else:
            logger.error("Failed matching 'metadata_item_id' '%d' to '%s': %s... Response =\n%s\n",
                         int(metadata_item_id),
                         new_name, new_guid, resp.text)

    except Exception:
        logger.exception("Exception matching 'metadata_item' %d: ", int(metadata_item_id))
    return False


def refresh_plex_item(config, metadata_item_id, new_name):
    try:
        url_params = {
            'X-Plex-Token': config['PLEX_TOKEN'],
        }
        url_str = '%s/library/metadata/%d/refresh' % (config['PLEX_LOCAL_URL'], int(metadata_item_id))

        requests.options(url_str, params=url_params, timeout=30)
        resp = requests.put(url_str, params=url_params, timeout=30)
        if resp.status_code == 200:
            logger.info("Successfully refreshed 'metadata_item_id' '%d' of '%s'.", int(metadata_item_id),
                        new_name)
            return True
        else:
            logger.error("Failed refreshing 'metadata_item_id' '%d' of '%s': Response =\n%s\n",
                         int(metadata_item_id),
                         new_name, resp.text)

    except Exception:
        logger.exception("Exception refreshing 'metadata_item' %d: ", int(metadata_item_id))
    return False