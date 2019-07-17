import time

import backoff
import requests

from helpers.misc import backoff_handler, dict_merge
from helpers.trakt import extract_list_user_and_key_from_url
from misc.log import logger

log = logger.get_logger(__name__)


class Trakt:
    non_user_lists = ['anticipated', 'trending',
                      'popular', 'boxoffice', 'watched', 'played']

    def __init__(self, cfg):
        self.cfg = cfg

    ############################################################
    # Requests
    ############################################################

    def _make_request(self, url, payload={}, authenticate_user=None, request_type='get'):
        headers, authenticate_user = self._headers(authenticate_user)

        if authenticate_user:
            url = url.replace('{authenticate_user}', authenticate_user)

        # make request
        if request_type == 'delete':
            req = requests.delete(url, headers=headers,
                                  params=payload, timeout=30)
        else:
            req = requests.get(url, headers=headers,
                               params=payload, timeout=30)
        log.debug("Request URL: %s", req.url)
        log.debug("Request Payload: %s", payload)
        log.debug("Request User: %s", authenticate_user)
        log.debug("Response Code: %d", req.status_code)

        return req

    @backoff.on_predicate(backoff.expo, lambda x: x is None, max_tries=4, on_backoff=backoff_handler)
    def _make_item_request(self, url, object_name, payload={}):
        payload = dict_merge(payload, {'extended': 'full'})

        try:
            req = self._make_request(url, payload)

            if req.status_code == 200:
                resp_json = req.json()
                return resp_json
            elif req.status_code == 401:
                log.error(
                    "The authentication to Trakt is revoked. Please re-authenticate.")
                exit()
            else:
                log.error("Failed to retrieve %s, request response: %d",
                          object_name, req.status_code)
                return None
        except Exception:
            log.exception("Exception retrieving %s: ", object_name)
        return None

    @backoff.on_predicate(backoff.expo, lambda x: x is None, max_tries=4, on_backoff=backoff_handler)
    def _make_items_request(self, url, limit, languages, type_name, object_name, authenticate_user=None, payload={},
                            sleep_between=5, genres=None):
        if not languages:
            languages = ['en']

        payload = dict_merge(payload, {
                             'extended': 'full', 'limit': limit, 'page': 1, 'languages': ','.join(languages)})
        if genres:
            payload['genres'] = genres

        processed = []

        if authenticate_user:
            type_name = type_name.replace(
                '{authenticate_user}', self._user_used_for_authentication(authenticate_user))

        try:
            while True:
                req = self._make_request(url, payload, authenticate_user)

                current_page = payload['page']
                total_pages = 0 if 'X-Pagination-Page-Count' not in req.headers else int(
                    req.headers['X-Pagination-Page-Count'])

                log.debug("Response Page: %d of %d", current_page, total_pages)

                if req.status_code == 200:
                    resp_json = req.json()
                    if type_name == 'person' and 'cast' in resp_json:
                        # handle person results
                        for item in resp_json['cast']:
                            if item not in processed:
                                if object_name.rstrip('s') not in item and 'title' in item:
                                    processed.append(
                                        {object_name.rstrip('s'): item})
                                else:
                                    processed.append(item)
                    else:
                        for item in resp_json:
                            if item not in processed:
                                if object_name.rstrip('s') not in item and 'title' in item:
                                    processed.append(
                                        {object_name.rstrip('s'): item})
                                else:
                                    processed.append(item)

                    # check if we have fetched the last page, break if so
                    if total_pages == 0:
                        log.debug("There were no more pages to retrieve")
                        break
                    elif current_page >= total_pages:
                        log.debug(
                            "There are no more pages to retrieve results from")
                        break
                    else:
                        log.info(
                            "There are %d pages left to retrieve results from", total_pages - current_page)
                        payload['page'] += 1
                        time.sleep(sleep_between)
                elif req.status_code == 401:
                    log.error(
                        "The authentication to Trakt is revoked. Please re-authenticate.")
                    exit()
                else:
                    log.error("Failed to retrieve %s %s, request response: %d",
                              type_name, object_name, req.status_code)
                    break

            if len(processed):
                log.debug("Found %d %s %s", len(
                    processed), type_name, object_name)
                return processed
            return None
        except Exception:
            log.exception("Exception retrieving %s %s: ",
                          type_name, object_name)
        return None

    def validate_client_id(self):
        try:
            # request anticipated shows to validate client_id
            req = self._make_request(
                url='https://api.trakt.tv/shows/anticipated',
            )

            if req.status_code == 200:
                return True
            return False
        except Exception:
            log.exception("Exception validating client_id: ")
        return False

    def remove_recommended_item(self, item_type, trakt_id, authenticate_user=None):
        ret = self._make_request(
            url='https://api.trakt.tv/recommendations/%ss/%s' % (
                item_type, str(trakt_id)),
            authenticate_user=authenticate_user,
            request_type='delete'
        )
        if ret.status_code == 204:
            return True
        return False

    ############################################################
    # OAuth Authentication
    ############################################################

    def __oauth_request_device_code(self):
        log.info(
            "We're talking to Trakt to get your verification code. Please wait a moment...")

        payload = {'client_id': self.cfg.trakt.client_id}

        print(self._headers_without_authentication())

        # Request device code
        req = requests.post('https://api.trakt.tv/oauth/device/code', params=payload,
                            headers=self._headers_without_authentication())
        device_code_response = req.json()

        # Display needed information to the user
        log.info('Go to: %s on any device and enter %s. We\'ll be polling Trakt every %s seconds for a reply',
                 device_code_response['verification_url'], device_code_response['user_code'],
                 device_code_response['interval'])

        return device_code_response

    def __oauth_process_token_request(self, req):
        success = False

        if req.status_code == 200:
            # Success; saving the access token
            access_token_response = req.json()
            access_token = access_token_response['access_token']

            # But first we need to find out what user this token belongs to
            temp_headers = self._headers_without_authentication()
            temp_headers['Authorization'] = 'Bearer ' + access_token

            req = requests.get(
                'https://api.trakt.tv/users/me', headers=temp_headers)

            from misc.config import Config
            new_config = Config()

            new_config.merge_settings({
                "trakt": {
                    req.json()['username']: access_token_response
                }
            })

            success = True
        elif req.status_code == 404:
            log.debug('The device code was wrong')
            log.error(
                'Whoops, something went wrong; aborting the authentication process')
        elif req.status_code == 409:
            log.error(
                'You\'ve already authenticated this application; aborting the authentication process')
        elif req.status_code == 410:
            log.error(
                'The authentication process has expired; please start again')
        elif req.status_code == 418:
            log.error(
                'You\'ve denied the authentication; are you sure? Please try again')
        elif req.status_code == 429:
            log.debug('We\'re polling too quickly.')

        return success, req.status_code

    def __oauth_poll_for_access_token(self, device_code, polling_interval=5, polling_expire=600):
        polling_start = time.time()
        time.sleep(polling_interval)
        tries = 0

        while time.time() - polling_start < polling_expire:
            tries += 1

            log.debug('Polling Trakt for the %sth time; %s seconds left', tries,
                      polling_expire - round(time.time() - polling_start))

            payload = {'code': device_code, 'client_id': self.cfg.trakt.client_id,
                       'client_secret': self.cfg.trakt.client_secret, 'grant_type': 'authorization_code'}

            # Poll Trakt for access token
            req = requests.post('https://api.trakt.tv/oauth/device/token', params=payload,
                                headers=self._headers_without_authentication())

            success, status_code = self.__oauth_process_token_request(req)

            if success:
                break
            elif status_code == 426:
                log.debug('Increasing the interval by one second')
                polling_interval += 1

            time.sleep(polling_interval)
        return False

    def __oauth_refresh_access_token(self, refresh_token):
        payload = {'refresh_token': refresh_token, 'client_id': self.cfg.trakt.client_id,
                   'client_secret': self.cfg.trakt.client_secret, 'grant_type': 'refresh_token'}

        req = requests.post('https://api.trakt.tv/oauth/token', params=payload,
                            headers=self._headers_without_authentication())

        success, status_code = self.__oauth_process_token_request(req)

        return success

    def oauth_authentication(self):
        try:
            device_code_response = self.__oauth_request_device_code()

            if self.__oauth_poll_for_access_token(device_code_response['device_code'],
                                                  device_code_response['interval'],
                                                  device_code_response['expires_in']):
                return True
        except Exception:
            log.exception("Exception occurred when authenticating user")
        return False

    def _get_first_authenticated_user(self):
        import copy

        users = copy.copy(self.cfg.trakt)

        if 'client_id' in users.keys():
            users.pop('client_id')

        if 'client_secret' in users.keys():
            users.pop('client_secret')

        if len(users) > 0:
            return list(users.keys())[0]

    def _user_is_authenticated(self, user):
        return user in self.cfg['trakt'].keys()

    def _renew_oauth_token_if_expired(self, user):
        token_information = self.cfg['trakt'][user]

        # Check if the acces_token for the user is expired
        expires_at = token_information['created_at'] + \
            token_information['expires_in']
        if expires_at < round(time.time()):
            log.info("The access token for the user %s has expired. We're requesting a new one; please wait a moment.",
                     user)

            if self.__oauth_refresh_access_token(token_information["refresh_token"]):
                log.info(
                    "The access token for the user %s has been refreshed. Please restart the application.", user)

    def _user_used_for_authentication(self, user=None):
        if user is None:
            user = self._get_first_authenticated_user()
        elif not self._user_is_authenticated(user):
            log.error('The user %s you specified to use for authentication is not authenticated yet. ' +
                      'Authenticate the user first, before you use it to retrieve lists.', user)

            exit()

        return user

    def _headers_without_authentication(self):
        return {
            'Content-Type': 'application/json',
            'trakt-api-version': '2',
            'trakt-api-key': self.cfg.trakt.client_id
        }

    def _headers(self, user=None):
        headers = self._headers_without_authentication()

        user = self._user_used_for_authentication(user)

        if user is not None:
            self._renew_oauth_token_if_expired(user)
            headers['Authorization'] = 'Bearer ' + \
                self.cfg['trakt'][user]['access_token']
        else:
            log.info('No user')

        return headers, user

    ############################################################
    # Shows
    ############################################################

    def get_show(self, show_id):
        return self._make_item_request(
            url='https://api.trakt.tv/shows/%s' % str(show_id),
            object_name='show',
        )

    def get_trending_shows(self, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/shows/trending',
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='trending',
            genres=genres
        )

    def get_popular_shows(self, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/shows/popular',
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='popular',
            genres=genres
        )

    def get_anticipated_shows(self, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/shows/anticipated',
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='anticipated',
            genres=genres
        )

    def get_person_shows(self, person, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/people/%s/shows' % person,
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='person',
            genres=genres
        )

    def get_most_played_shows(self, limit=1000, languages=None, genres=None, most_type=None):
        return self._make_items_request(
            url='https://api.trakt.tv/shows/played/%s' % (
                'weekly' if not most_type else most_type),
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='played',
            genres=genres
        )

    def get_most_watched_shows(self, limit=1000, languages=None, genres=None, most_type=None):
        return self._make_items_request(
            url='https://api.trakt.tv/shows/watched/%s' % (
                'weekly' if not most_type else most_type),
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='watched',
            genres=genres
        )

    def get_recommended_shows(self, authenticate_user=None, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/recommendations/shows',
            authenticate_user=authenticate_user,
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='recommended from {authenticate_user}',
            genres=genres
        )

    def get_watchlist_shows(self, authenticate_user=None, limit=1000, languages=None):
        return self._make_items_request(
            url='https://api.trakt.tv/users/{authenticate_user}/watchlist/shows',
            authenticate_user=authenticate_user,
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name='watchlist from {authenticate_user}',
        )

    def get_user_list_shows(self, list_url, authenticate_user=None, limit=1000, languages=None):
        list_user, list_key = extract_list_user_and_key_from_url(list_url)

        log.debug('Fetching %s from %s', list_key, list_user)

        return self._make_items_request(
            url='https://api.trakt.tv/users/' + list_user +
                '/lists/' + list_key + '/items/shows',
            authenticate_user=authenticate_user,
            limit=limit,
            languages=languages,
            object_name='shows',
            type_name=(list_key + ' from ' + list_user),
        )

    ############################################################
    # Movies
    ############################################################

    def get_movie(self, movie_id):
        return self._make_item_request(
            url='https://api.trakt.tv/movies/%s' % str(movie_id),
            object_name='movie',
        )

    def get_trending_movies(self, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/movies/trending',
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='trending',
            genres=genres
        )

    def get_popular_movies(self, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/movies/popular',
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='popular',
            genres=genres
        )

    def get_anticipated_movies(self, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/movies/anticipated',
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='anticipated',
            genres=genres
        )

    def get_person_movies(self, person, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/people/%s/movies' % person,
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='person',
            genres=genres
        )

    def get_most_played_movies(self, limit=1000, languages=None, genres=None, most_type=None):
        return self._make_items_request(
            url='https://api.trakt.tv/movies/played/%s' % (
                'weekly' if not most_type else most_type),
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='played',
            genres=genres
        )

    def get_most_watched_movies(self, limit=1000, languages=None, genres=None, most_type=None):
        return self._make_items_request(
            url='https://api.trakt.tv/movies/watched/%s' % (
                'weekly' if not most_type else most_type),
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='watched',
            genres=genres
        )

    def get_boxoffice_movies(self, limit=1000, languages=None):
        return self._make_items_request(
            url='https://api.trakt.tv/movies/boxoffice',
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='anticipated',
        )

    def get_recommended_movies(self, authenticate_user=None, limit=1000, languages=None, genres=None):
        return self._make_items_request(
            url='https://api.trakt.tv/recommendations/movies',
            authenticate_user=authenticate_user,
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='recommended from {authenticate_user}',
            genres=genres
        )

    def get_watchlist_movies(self, authenticate_user=None, limit=1000, languages=None):
        return self._make_items_request(
            url='https://api.trakt.tv/users/{authenticate_user}/watchlist/movies',
            authenticate_user=authenticate_user,
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name='watchlist from {authenticate_user}',
        )

    def get_user_list_movies(self, list_url, authenticate_user=None, limit=1000, languages=None):
        list_user, list_key = extract_list_user_and_key_from_url(list_url)

        log.debug('Fetching %s from %s', list_key, list_user)

        return self._make_items_request(
            url='https://api.trakt.tv/users/' + list_user +
                '/lists/' + list_key + '/items/movies',
            authenticate_user=authenticate_user,
            limit=limit,
            languages=languages,
            object_name='movies',
            type_name=(list_key + ' from ' + list_user),
        )
