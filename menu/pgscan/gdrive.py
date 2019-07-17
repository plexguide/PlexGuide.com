import json
import logging
import os
from urllib import urlencode

import backoff
import requests
from sqlitedict import SqliteDict

import utils

logger = logging.getLogger("GDRIVE")


class Gdrive:
    def __init__(self, config, token_path, cache_path):
        self.cfg = config
        self.token_path = token_path
        self.cache_path = cache_path
        self.token = None
        self.cache = None

    def first_run(self):
        # token file
        if not os.path.exists(self.token_path):
            # token.json does not exist, lets do the first run auth process
            print("Visit %s and authorize against the account you wish to use" %
                  self.authorize_url())
            auth_code = raw_input('Enter authorization code: ')
            if self.first_access_token(auth_code) and self.token is not None:
                self.dump_token()
            else:
                logger.error(
                    "Failed to authorize with the supplied client_id/client_secret/auth_code...")
                return False
        else:
            self.token = utils.load_json(self.token_path)

        # cache file
        self.cache = SqliteDict(self.cache_path, tablename='cache', encode=json.dumps, decode=json.loads,
                                autocommit=False)
        return True

    def authorize_url(self):
        payload = {
            'client_id': self.cfg['GDRIVE']['CLIENT_ID'],
            'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
            'response_type': 'code',
            'access_type': 'offline',
            'scope': 'https://www.googleapis.com/auth/drive'
        }
        url = 'https://accounts.google.com/o/oauth2/v2/auth?' + \
            urlencode(payload)
        return url

    def first_access_token(self, auth_code):
        logger.info("Requesting access token for auth code %r", auth_code)
        payload = {
            'code': auth_code,
            'client_id': self.cfg['GDRIVE']['CLIENT_ID'],
            'client_secret': self.cfg['GDRIVE']['CLIENT_SECRET'],
            'grant_type': 'authorization_code',
            'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
        }
        success, resp, data = self._make_request('https://www.googleapis.com/oauth2/v4/token', data=payload,
                                                 headers={}, request_type='post')
        if success and resp.status_code == 200:
            logger.info("Retrieved first access token!")
            self.token = data
            self.token['page_token'] = ''
            return True
        else:
            logger.error("Error retrieving first access_token:\n%s", data)
            return False

    def refresh_access_token(self):
        logger.debug("Renewing access token...")
        payload = {
            'refresh_token': self.token['refresh_token'],
            'client_id': self.cfg['GDRIVE']['CLIENT_ID'],
            'client_secret': self.cfg['GDRIVE']['CLIENT_SECRET'],
            'grant_type': 'refresh_token',
        }
        success, resp, data = self._make_request('https://www.googleapis.com/oauth2/v4/token', data=payload,
                                                 headers={}, request_type='post')
        if success and resp.status_code == 200 and 'access_token' in data:
            logger.info("Renewed access token!")

            refresh_token = self.token['refresh_token']
            page_token = self.token['page_token']
            self.token = data
            if 'refresh_token' not in self.token or not self.token['refresh_token']:
                self.token['refresh_token'] = refresh_token
            self.token['page_token'] = page_token
            self.dump_token()
            return True
        else:
            logger.error("Error renewing access token:\n%s", data)
            return False

    def get_changes_first_page_token(self):
        success, resp, data = self._make_request('https://www.googleapis.com/drive/v3/changes/startPageToken',
                                                 params={'supportsTeamDrives': self.cfg['GDRIVE']['TEAMDRIVE']})
        if success and resp.status_code == 200:
            if 'startPageToken' not in data:
                logger.error(
                    "Failed to retrieve startPageToken from returned startPageToken:\n%s", data)
                return False
            self.token['page_token'] = data['startPageToken']
            self.dump_token()
            return True
        else:
            logger.error("Error retrieving first page token:\n%s", data)
            return False

    def get_changes(self):
        success, resp, data = self._make_request('https://www.googleapis.com/drive/v3/changes',
                                                 params={'pageToken': self.token['page_token'], 'pageSize': 1000,
                                                         'includeRemoved': True,
                                                         'includeTeamDriveItems': self.cfg['GDRIVE'][
                                                             'TEAMDRIVE'],
                                                         'supportsTeamDrives': self.cfg['GDRIVE']['TEAMDRIVE'],
                                                         'fields': 'changes(file(md5Checksum,mimeType,modifiedTime,'
                                                                   'name,parents,teamDriveId,trashed),'
                                                                   'fileId,removed,teamDrive(id,name),'
                                                                   'teamDriveId),newStartPageToken,nextPageToken'})
        if success and resp.status_code == 200:
            # page token logic
            if data is not None and 'nextPageToken' in data:
                self.token['page_token'] = data['nextPageToken']
                self.dump_token()
            elif data is not None and 'newStartPageToken' in data:
                self.token['page_token'] = data['newStartPageToken']
                self.dump_token()
            else:
                logger.error("Unexpected response while polling for changes from page %s:\n%s",
                             str(self.token['page_token']), data)
                return False, data
            return True, data
        else:
            logger.error("Error getting page changes for page_token %r:\n%s",
                         self.token['page_token'], data)
            return False, data

    def get_id_metadata(self, item_id, teamdrive_id=None):
        # return cache from metadata if available
        cached_metadata = self._get_cached_metdata(item_id)
        if cached_metadata:
            return True, cached_metadata

        # does item_id match teamdrive_id?
        if teamdrive_id is not None and item_id == teamdrive_id:
            success, resp, data = self._make_request(
                'https://www.googleapis.com/drive/v3/teamdrives/%s' % str(item_id))
            if success and resp.status_code == 200 and 'name' in data:
                # we successfully retrieved this teamdrive info, lets place a mimeType key in the result
                # so we know it needs to be cached
                data['mimeType'] = 'application/vnd.google-apps.folder'
        else:
            # retrieve file metadata
            success, resp, data = self._make_request('https://www.googleapis.com/drive/v3/files/%s' % str(item_id),
                                                     params={
                                                         'supportsTeamDrives': self.cfg['GDRIVE']['TEAMDRIVE'],
                                                         'fields': 'id,md5Checksum,mimeType,modifiedTime,name,parents,'
                                                                   'trashed,teamDriveId'})
        if success and resp.status_code == 200:
            return True, data
        else:
            logger.error(
                "Error retrieving metadata for item %r:\n%s", item_id, data)
            return False, data

    def get_id_file_paths(self, item_id, teamdrive_id=None):
        file_paths = []
        added_to_cache = 0

        try:
            def get_item_paths(obj_id, path, paths, new_cache_entries, teamdrive_id=None):
                success, obj = self.get_id_metadata(obj_id, teamdrive_id)
                if not success:
                    return new_cache_entries

                teamdrive_id = teamdrive_id if 'teamDriveId' not in obj else obj['teamDriveId']

                # add item object to cache if we know its not from cache
                if 'mimeType' in obj:
                    # we know this is a new item fetched from the api, because the cache does not store this field
                    self.add_item_to_cache(
                        obj['id'], obj['name'], [] if 'parents' not in obj else obj['parents'])
                    new_cache_entries += 1

                if path.strip() == '':
                    path = obj['name']
                else:
                    path = os.path.join(obj['name'], path)

                if 'parents' in obj and obj['parents']:
                    for parent in obj['parents']:
                        new_cache_entries += get_item_paths(
                            parent, path, paths, new_cache_entries, teamdrive_id)

                if (not obj or 'parents' not in obj or not obj['parents']) and len(path):
                    paths.append(path)
                    return new_cache_entries
                return new_cache_entries

            added_to_cache += get_item_paths(item_id, '',
                                             file_paths, added_to_cache, teamdrive_id)
            if added_to_cache:
                logger.debug("Dumping cache due to new entries!")
                self.dump_cache()

            if len(file_paths):
                return True, file_paths
            else:
                return False, file_paths

        except Exception:
            logger.exception(
                "Exception retrieving filepaths for '%s': ", item_id)

        return False, []

    # cache
    def add_item_to_cache(self, item_id, item_name, item_parents):
        if item_id not in self.cache:
            logger.info("Added '%s' to cache: %s", item_id, item_name)
        self.cache[item_id] = {'name': item_name, 'parents': item_parents}
        return

    def remove_item_from_cache(self, item_id):
        if self.cache.pop(item_id, None):
            return True
        return False

    # dump jsons
    def dump_token(self):
        utils.dump_json(self.token_path, self.token)
        return

    def dump_cache(self):
        self.cache.commit()
        return

    ############################################################
    # INTERNALS
    ############################################################

    # cache
    def _get_cached_metdata(self, item_id):
        if item_id in self.cache:
            return self.cache[item_id]
        return None

    # requests
    @backoff.on_predicate(backoff.expo, lambda x: not x[0] and (
        'error' in x[2] and 'code' in x[2]['error'] and x[2]['error']['code'] != 401), max_tries=8)
    def _make_request(self, url, headers=None, data=None, params=None, request_type='get'):
        refreshed_token = False

        while True:
            if headers is None and self.token:
                auth_headers = {
                    'Authorization': 'Bearer %s' % self.token['access_token'],
                }
            else:
                auth_headers = {}

            resp = None
            if request_type == 'get':
                resp = requests.get(url, params=params, headers=headers if headers is not None else auth_headers,
                                    timeout=30)
            elif request_type == 'post':
                resp = requests.post(url, data=data, headers=headers if headers is not None else auth_headers,
                                     timeout=30)
            else:
                return False, resp, {
                    'error': {'code': 401, 'message': 'Invalid request_type was supplied to _make_request'}}

            # response logic
            try:
                data = resp.json()
            except ValueError:
                logger.exception("Exception while decoding response from Google Drive for data:\n%s\nTraceback: ",
                                 resp.text)
                return False, resp, {
                    'error': {'code': resp.status_code, 'message': 'Failed to json decode Google Drive response'}}

            if 'error' in data and 'code' in data['error'] and (
                    'message' in data['error'] and 'Invalid Credentials' in data['error']['message']):
                # the token has expired.
                if not refreshed_token:
                    refreshed_token = True
                    self.refresh_access_token()
                    continue
                else:
                    # attempt was already made to refresh token
                    return False, resp, data

            if resp.status_code == 200:
                return True, resp, data
            else:
                return False, resp, data
