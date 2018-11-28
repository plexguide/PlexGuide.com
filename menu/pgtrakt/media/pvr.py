import os.path
from abc import ABC, abstractmethod

import backoff
import requests

from helpers.misc import backoff_handler
from helpers import str as misc_str
from helpers import misc
from misc.log import logger

log = logger.get_logger(__name__)


class PVR(ABC):
    def __init__(self, server_url, api_key):
        self.server_url = server_url
        self.api_key = api_key
        self.headers = {
            'Content-Type': 'application/json',
            'X-Api-Key': self.api_key,
        }

    def validate_api_key(self):
        try:
            # request system status to validate api_key
            req = requests.get(
                os.path.join(misc_str.ensure_endswith(self.server_url, "/"), 'api/system/status'),
                headers=self.headers,
                timeout=60,
                allow_redirects=False
            )
            log.debug("Request Response: %d", req.status_code)

            if req.status_code == 200 and 'version' in req.json():
                return True
            return False
        except Exception:
            log.exception("Exception validating api_key: ")
        return False

    @abstractmethod
    def get_objects(self):
        pass

    @backoff.on_predicate(backoff.expo, lambda x: x is None, max_tries=4, on_backoff=backoff_handler)
    def _get_objects(self, endpoint):
        try:
            # make request
            req = requests.get(
                os.path.join(misc_str.ensure_endswith(self.server_url, "/"), endpoint),
                headers=self.headers,
                timeout=60,
                allow_redirects=False
            )
            log.debug("Request URL: %s", req.url)
            log.debug("Request Response: %d", req.status_code)

            if req.status_code == 200:
                resp_json = req.json()
                log.debug("Found %d objects", len(resp_json))
                return resp_json
            else:
                log.error("Failed to retrieve all objects, request response: %d", req.status_code)
        except Exception:
            log.exception("Exception retrieving objects: ")
        return None

    @backoff.on_predicate(backoff.expo, lambda x: x is None, max_tries=4, on_backoff=backoff_handler)
    def get_profile_id(self, profile_name):
        try:
            # make request
            req = requests.get(
                os.path.join(misc_str.ensure_endswith(self.server_url, "/"), 'api/profile'),
                headers=self.headers,
                timeout=60,
                allow_redirects=False
            )
            log.debug("Request URL: %s", req.url)
            log.debug("Request Response: %d", req.status_code)

            if req.status_code == 200:
                resp_json = req.json()
                for profile in resp_json:
                    if profile['name'].lower() == profile_name.lower():
                        log.debug("Found id of %s profile: %d", profile_name, profile['id'])
                        return profile['id']
                    log.debug("Profile %s with id %d did not match %s", profile['name'], profile['id'], profile_name)
            else:
                log.error("Failed to retrieve all quality profiles, request response: %d", req.status_code)
        except Exception:
            log.exception("Exception retrieving id of profile %s: ", profile_name)
        return None

    def _prepare_add_object_payload(self, title, title_slug, profile_id, root_folder):
        return {
            'title': title,
            'titleSlug': title_slug,
            'qualityProfileId': profile_id,
            'images': [],
            'monitored': True,
            'rootFolderPath': root_folder,
            'addOptions': {
                'ignoreEpisodesWithFiles': False,
                'ignoreEpisodesWithoutFiles': False,
            }
        }

    @backoff.on_predicate(backoff.expo, lambda x: x is None, max_tries=4, on_backoff=backoff_handler)
    def _add_object(self, endpoint, payload, identifier_field, identifier):
        try:
            # make request
            req = requests.post(
                os.path.join(misc_str.ensure_endswith(self.server_url, "/"), endpoint),
                headers=self.headers,
                json=payload,
                timeout=60,
                allow_redirects=False
            )
            log.debug("Request URL: %s", req.url)
            log.debug("Request Payload: %s", payload)
            log.debug("Request Response Code: %d", req.status_code)
            log.debug("Request Response Text:\n%s", req.text)

            response_json = None
            if 'json' in req.headers['Content-Type'].lower():
                response_json = misc.get_response_dict(req.json(), identifier_field, identifier)

            if (req.status_code == 201 or req.status_code == 200) \
                    and (response_json and identifier_field in response_json) \
                    and response_json[identifier_field] == identifier:
                log.debug("Successfully added %s (%d)", payload['title'], identifier)
                return True
            elif response_json and ('errorMessage' in response_json or 'message' in response_json):
                message = response_json['errorMessage'] if 'errorMessage' in response_json else response_json['message']

                log.error("Failed to add %s (%d) - status_code: %d, reason: %s", payload['title'], identifier,
                          req.status_code, message)
                return False
            else:
                log.error("Failed to add %s (%d), unexpected response:\n%s", payload['title'], identifier, req.text)
                return False
        except Exception:
            log.exception("Exception adding %s (%d): ", payload['title'], identifier)
        return None
