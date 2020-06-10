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
    try:
        with sqlite3.connect(config['PLEX_DATABASE_PATH']) as conn:
            conn.row_factory = sqlite3.Row
            conn.text_factory = str
            with closing(conn.cursor()) as c:
                # check if file exists in plex
                logger.debug("Checking if root folder path '%s' matches Plex Library root path in the Plex DB.", path)
                section_data = c.execute("SELECT library_section_id,root_path FROM section_locations").fetchall()
                for section_id, root_path in section_data:
                    if path.startswith(root_path + os.sep):
                        logger.debug("Plex Library Section ID '%d' matching root folder '%s' was found in the Plex DB.",
                                     section_id, root_path)
                        return int(section_id)
                logger.error("Unable to map '%s' to a Section ID.", path)

    except Exception:
        logger.exception("Exception while trying to map '%s' to a Section ID in the Plex DB: ", path)
    return -1


def ensure_valid_os_path_sep(path):
    try:
        if path.startswith('/'):
            # replace \ with /
            return path.replace('\\', '/')
        elif '\\' in path:
            # replace / with \
            return path.replace('/', '\\')
    except Exception:
        logger.exception("Exception while trying to ensure valid os path seperator for: '%s'", path)

    return path


def map_pushed_path(config, path):
    for mapped_path, mappings in config['SERVER_PATH_MAPPINGS'].items():
        for mapping in mappings:
            if path.startswith(mapping):
                logger.debug("Mapping server path '%s' to '%s'.", mapping, mapped_path)
                return ensure_valid_os_path_sep(path.replace(mapping, mapped_path))
    return path


def map_pushed_path_file_exists(config, path):
    for mapped_path, mappings in config['SERVER_FILE_EXIST_PATH_MAPPINGS'].items():
        for mapping in mappings:
            if path.startswith(mapping):
                logger.debug("Mapping file check path '%s' to '%s'.", mapping, mapped_path)
                return ensure_valid_os_path_sep(path.replace(mapping, mapped_path))
    return path


# For Rclone dir cache clear request
def map_file_exists_path_for_rclone(config, path):
    for mapped_path, mappings in config['RCLONE']['RC_CACHE_REFRESH']['FILE_EXISTS_TO_REMOTE_MAPPINGS'].items():
        for mapping in mappings:
            if path.startswith(mapping):
                logger.debug("Mapping Rclone file check path '%s' to '%s'.", mapping, mapped_path)
                return path.replace(mapping, mapped_path)
    return path


def is_process_running(process_name, plex_container=None):
    try:
        for process in psutil.process_iter():
            if process.name().lower() == process_name.lower():
                if not plex_container:
                    return True, process, plex_container
                # plex_container was not None
                # we need to check if this processes is from the container we are interested in
                get_pid_container = "docker inspect --format '{{.Name}}' \"$(cat /proc/%s/cgroup |head -n 1 " \
                                    "|cut -d / -f 3)\" | sed 's/^\///'" % process.pid
                process_container = run_command(get_pid_container, True)
                logger.debug("Using: %s", get_pid_container)
                logger.debug("Docker Container For PID %s: %r", process.pid,
                             process_container.strip() if process_container is not None else 'Unknown???')
                if process_container is not None and isinstance(process_container, str) and \
                        process_container.strip().lower() == plex_container.lower():
                    return True, process, process_container.strip()

        return False, None, plex_container
    except psutil.ZombieProcess:
        return False, None, plex_container
    except Exception:
        logger.exception("Exception checking for process: '%s': ", process_name)
        return False, None, plex_container


def wait_running_process(process_name, use_docker=False, plex_container=None):
    try:
        running, process, container = is_process_running(process_name,
                                                         None if not use_docker or not plex_container else
                                                         plex_container)
        while running and process:
            logger.info("'%s' is running, pid: %d,%s cmdline: %r. Checking again in 60 seconds...", process.name(),
                        process.pid,
                        ' container: %s,' % container.strip() if use_docker and isinstance(container, str) else '',
                        process.cmdline())
            time.sleep(60)
            running, process, container = is_process_running(process_name,
                                                             None if not use_docker or not plex_container else
                                                             plex_container)

        return True

    except Exception:
        logger.exception("Exception waiting for process: '%s'", process_name())

        return False


def run_command(command, get_output=False):
    total_output = ''
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    while True:
        output = str(process.stdout.readline()).lstrip('b').replace('\\n', '').strip()
        if output and len(output) >= 3:
            if not get_output:
                if len(output) >= 8:
                    logger.info(output)
            else:
                total_output += output

        if process.poll() is not None:
            break

    rc = process.poll()
    return rc if not get_output else total_output


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
                    logger.debug("Using priority '%d' for path '%s'", int(priority), scan_path)
                    return int(priority)
        logger.debug("Using default priority '0' for path '%s'", scan_path)
    except Exception:
        logger.exception("Exception determining priority to use for '%s': ", scan_path)
    return 0


def rclone_rc_clear_cache(config, scan_path):
    try:
        rclone_rc_expire_url = urljoin(config['RCLONE']['RC_CACHE_REFRESH']['RC_URL'], 'cache/expire')
        rclone_rc_refresh_url = urljoin(config['RCLONE']['RC_CACHE_REFRESH']['RC_URL'], 'vfs/refresh')

        cache_clear_path = map_file_exists_path_for_rclone(config, scan_path).lstrip(os.path.sep)
        logger.debug("Top level cache_clear_path: '%s'", cache_clear_path)

        while True:
            last_clear_path = cache_clear_path
            cache_clear_path = os.path.dirname(cache_clear_path)
            if cache_clear_path == last_clear_path or not len(cache_clear_path):
                # is the last path we tried to clear, the same as this path, if so, abort
                logger.error(
                    "Aborting Rclone dir cache clear request for '%s' due to directory level exhaustion, last level: '%s'",
                    scan_path, last_clear_path)
                return False
            else:
                last_clear_path = cache_clear_path

            # send Rclone mount dir cache clear request
            logger.info("Sending Rclone mount dir cache clear request for: '%s'", cache_clear_path)
            try:
                # try cache clear
                resp = requests.post(rclone_rc_expire_url, json={'remote': cache_clear_path}, timeout=120)
                if '{' in resp.text and '}' in resp.text:
                    data = resp.json()
                    if 'error' in data:
                        # try to vfs/refresh as fallback
                        resp = requests.post(rclone_rc_refresh_url, json={'dir': cache_clear_path}, timeout=120)
                        if '{' in resp.text and '}' in resp.text:
                            data = resp.json()
                            if 'result' in data and cache_clear_path in data['result'] \
                                    and data['result'][cache_clear_path] == 'OK':
                                # successfully vfs refreshed
                                logger.info("Successfully refreshed Rclone VFS mount's dir cache for '%s'",
                                            cache_clear_path)
                                return True

                        logger.info("Failed to clear Rclone mount's dir cache for '%s': %s", cache_clear_path,
                                    data['error'] if 'error' in data else data)
                        continue
                    elif ('status' in data and 'message' in data) and data['status'] == 'ok':
                        logger.info("Successfully cleared Rclone Cache mount's dir cache for '%s'", cache_clear_path)
                        return True

                # abort on unexpected response (no json response, no error/status & message in returned json
                logger.error("Unexpected Rclone mount dir cache clear response from %s while trying to clear '%s': %s",
                             rclone_rc_expire_url, cache_clear_path, resp.text)
                break

            except Exception:
                logger.exception("Exception sending Rclone mount dir cache clear request to %s for '%s': ",
                                 rclone_rc_expire_url,
                                 cache_clear_path)
                break

    except Exception:
        logger.exception("Exception clearing Rclone mount dir cache for '%s': ", scan_path)
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


def remove_files_exist_in_plex_database(config, file_paths):
    removed_items = 0
    plex_db_path = config['PLEX_DATABASE_PATH']
    try:
        if plex_db_path and os.path.exists(plex_db_path):
            with sqlite3.connect(plex_db_path) as conn:
                conn.row_factory = sqlite3.Row
                with closing(conn.cursor()) as c:
                    for file_path in copy(file_paths):
                        # check if file exists in plex
                        file_name = os.path.basename(file_path)
                        file_path_plex = map_pushed_path(config, file_path)
                        logger.debug("Checking to see if '%s' exists in the Plex DB located at '%s'", file_path_plex,
                                     plex_db_path)
                        found_item = c.execute("SELECT size FROM media_parts WHERE file LIKE ?",
                                               ('%' + file_path_plex,)) \
                            .fetchone()
                        file_path_actual = map_pushed_path_file_exists(config, file_path_plex)
                        # should plex file size and file size on disk be checked?
                        disk_file_size_check = True

                        if 'DISABLE_DISK_FILE_SIZE_CHECK' in config['GOOGLE'] \
                                and config['GOOGLE']['DISABLE_DISK_FILE_SIZE_CHECK']:
                            disk_file_size_check = False

                        if found_item:
                            logger.debug("'%s' was found in the Plex DB media_parts table.", file_name)
                            skip_file = False
                            if not disk_file_size_check:
                                skip_file = True
                            elif os.path.isfile(file_path_actual):
                                # check if file sizes match in plex
                                file_size = os.path.getsize(file_path_actual)
                                logger.debug(
                                    "Checking to see if the file size of '%s' matches the existing file size of '%s' in the Plex DB.",
                                    file_size, found_item[0])
                                if file_size == found_item[0]:
                                    logger.debug("'%s' size matches size found in the Plex DB.", file_size)
                                    skip_file = True

                            if skip_file:
                                logger.debug("Removing path from scan queue: '%s'", file_path)
                                file_paths.remove(file_path)
                                removed_items += 1

    except Exception:
        logger.exception("Exception checking if %s exists in the Plex DB: ", file_paths)
    return removed_items


def allowed_scan_extension(file_path, extensions):
    check_path = file_path.lower()
    for ext in extensions:
        if check_path.endswith(ext.lower()):
            logger.debug("'%s' had allowed extension: %s", file_path, ext)
            return True
    logger.debug("'%s' did not have an allowed extension.", file_path)
    return False
