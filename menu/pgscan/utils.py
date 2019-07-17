import json
import logging
import os
import sqlite3
import subprocess
import sys
import time
from contextlib import closing
from copy import copy

import requests

try:
    from urlparse import urljoin
except ImportError:
    from urllib.parse import urljoin

import psutil

logger = logging.getLogger("UTILS")


def get_plex_section(config, path):
    for section, mappings in config['PLEX_SECTION_PATH_MAPPINGS'].items():
        for mapping in mappings:
            if mapping.lower() in path.lower():
                return int(section)
    logger.error("Unable to map '%s' to a section id....", path)
    return -1


def map_pushed_path(config, path):
    for mapped_path, mappings in config['SERVER_PATH_MAPPINGS'].items():
        for mapping in mappings:
            if mapping in path:
                logger.debug("Mapping '%s' to '%s'", mapping, mapped_path)
                return path.replace(mapping, mapped_path)
    return path


def map_pushed_path_file_exists(config, path):
    for mapped_path, mappings in config['SERVER_FILE_EXIST_PATH_MAPPINGS'].items():
        for mapping in mappings:
            if mapping in path:
                logger.debug("Mapping file check path '%s' to '%s'",
                             mapping, mapped_path)
                return path.replace(mapping, mapped_path)
    return path


def map_file_exists_path_for_rclone(config, path):
    for mapped_path, mappings in config['RCLONE_RC_CACHE_EXPIRE']['FILE_EXISTS_TO_REMOTE_MAPPINGS'].items():
        for mapping in mappings:
            if mapping in path:
                logger.debug(
                    "Mapping file check path '%s' to '%s' for rclone cache clear", mapping, mapped_path)
                return path.replace(mapping, mapped_path)
    return path


def is_process_running(process_name):
    try:
        for process in psutil.process_iter():
            if process.name().lower() == process_name.lower():
                return True, process

        return False, None
    except psutil.ZombieProcess:
        return False, None
    except Exception:
        logger.exception(
            "Exception checking for process: '%s': ", process_name)
        return False, None


def wait_running_process(process_name):
    try:
        running, process = is_process_running(process_name)
        while running and process:
            logger.info("'%s' is running, pid: %d, cmdline: %r. Checking again in 60 seconds...", process.name(),
                        process.pid, process.cmdline())
            time.sleep(60)
            running, process = is_process_running(process_name)

        return True

    except Exception:
        logger.exception("Exception waiting for process: '%s'", process_name())

        return False


def run_command(command):
    process = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    while True:
        output = str(process.stdout.readline()).lstrip(
            'b').replace('\\n', '').strip()
        if process.poll() is not None:
            break
        if output and len(output) >= 8:
            logger.info(output)

    rc = process.poll()
    return rc


def should_ignore(file_path, config):
    for item in config['SERVER_IGNORE_LIST']:
        if item.lower() in file_path.lower():
            return True, item

    return False, None


def remove_item_from_list(item, from_list):
    while item in from_list:
        from_list.pop(from_list.index(item))
    return


def get_priority(config, scan_path):
    try:
        for priority, paths in config['SERVER_SCAN_PRIORITIES'].items():
            for path in paths:
                if path.lower() in scan_path.lower():
                    logger.debug("Using priority %d for path '%s'",
                                 int(priority), scan_path)
                    return int(priority)
        logger.debug("Using default priority 0 for path '%s'", scan_path)
    except Exception:
        logger.exception(
            "Exception determining priority to use for '%s': ", scan_path)
    return 0


def rclone_rc_clear_cache(config, scan_path):
    try:
        rclone_rc_url = urljoin(
            config['RCLONE_RC_CACHE_EXPIRE']['RC_URL'], 'cache/expire')

        cache_clear_path = map_file_exists_path_for_rclone(
            config, scan_path).lstrip(os.path.sep)
        logger.debug("Top level cache_clear_path: '%s'", cache_clear_path)

        while True:
            last_clear_path = cache_clear_path
            cache_clear_path = os.path.dirname(cache_clear_path)
            if cache_clear_path == last_clear_path or not len(cache_clear_path):
                # is the last path we tried to clear, the same as this path, if so, abort
                logger.error("Aborting rclone cache clear for '%s' due to directory level exhaustion, last level: '%s'",
                             scan_path, last_clear_path)
                return False
            else:
                last_clear_path = cache_clear_path

            # send cache clear request
            logger.info("Sending rclone cache clear for: '%s'",
                        cache_clear_path)
            try:
                resp = requests.post(rclone_rc_url, json={
                                     'remote': cache_clear_path}, timeout=120)
                if '{' in resp.text and '}' in resp.text:
                    data = resp.json()
                    if 'error' in data:
                        logger.info(
                            "Failed to clear rclone cache for '%s': %s", cache_clear_path, data['error'])
                        continue
                    elif ('status' in data and 'message' in data) and data['status'] == 'ok':
                        logger.info(
                            "Successfully cleared rclone cache for '%s'", cache_clear_path)
                        return True

                # abort on unexpected response (no json response, no error/status & message in returned json
                logger.error("Unexpected rclone cache clear response from %s while trying to clear '%s': %s",
                             rclone_rc_url, cache_clear_path, resp.text)
                break

            except Exception:
                logger.exception("Exception sending rclone cache clear to %s for '%s': ", rclone_rc_url,
                                 cache_clear_path)
                break

    except Exception:
        logger.exception(
            "Exception clearing rclone directory cache for '%s': ", scan_path)
    return False


def load_json(file_path):
    if os.path.sep not in file_path:
        file_path = os.path.join(os.path.dirname(sys.argv[0]), file_path)

    with open(file_path, 'r') as fp:
        return json.load(fp)


def dump_json(file_path, obj, processing=True):
    if os.path.sep not in file_path:
        file_path = os.path.join(os.path.dirname(sys.argv[0]), file_path)

    with open(file_path, 'w') as fp:
        if processing:
            json.dump(obj, fp, indent=2, sort_keys=True)
        else:
            json.dump(obj, fp)
    return


def remove_files_exist_in_plex_database(file_paths, plex_db_path):
    removed_items = 0
    try:
        if plex_db_path and os.path.exists(plex_db_path):
            with sqlite3.connect(plex_db_path) as conn:
                conn.row_factory = sqlite3.Row
                with closing(conn.cursor()) as c:
                    for file_path in copy(file_paths):
                        # check if file exists in plex
                        file_name = os.path.basename(file_path)
                        logger.debug(
                            "Checking if '%s' exists in the plex database at '%s'", file_name, plex_db_path)
                        found_item = c.execute("SELECT * FROM media_parts WHERE file LIKE ?", ('%' + file_name,)) \
                            .fetchone()
                        if found_item:
                            logger.debug(
                                "'%s' was found in the plex media_parts table", file_name)
                            file_paths.remove(file_path)
                            removed_items += 1

    except Exception:
        logger.exception(
            "Exception checking if %s exists in the plex database: ", file_paths)
    return removed_items


def allowed_scan_extension(file_path, extensions):
    check_path = file_path.lower()
    for ext in extensions:
        if check_path.endswith(ext.lower()):
            logger.debug("'%s' had allowed extension: %s", file_path, ext)
            return True
    logger.debug("'%s' did not have an allowed extension", file_path)
    return False
