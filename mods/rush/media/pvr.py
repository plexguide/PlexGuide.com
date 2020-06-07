import os.path
from abc import ABC, abstractmethod
from distutils.version import LooseVersion as Version

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
    def get_quality_profile_id(self, profile_name):
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
                        log.debug("Found Quality Profile ID for \'%s\': %d", profile_name, profile['id'])
                        return profile['id']
                    log.debug("Profile \'%s\' with ID \'%d\' did not match Quality Profile \'%s\'", profile['name'],
                              profile['id'], profile_name)
            else:
                log.error("Failed to retrieve all quality profiles, request response: %d", req.status_code)
        except Exception:
            log.exception("Exception retrieving ID of quality profile %s: ", profile_name)
        return None

    @backoff.on_exception(backoff.expo, requests.exceptions.RequestException, max_tries=4, on_backoff=backoff_handler)
    def get_language_profile_id(self, language_name):
        try:
            # check if sonarr is v3

            # make request
            ver_req = requests.get(
                os.path.join(misc_str.ensure_endswith(self.server_url, "/"), 'api/system/status'),
                headers=self.headers,
                timeout=60,
                allow_redirects=False
            )

            if ver_req.status_code == 200:
                ver_resp_json = ver_req.json()
                if not Version(ver_resp_json['version']) > Version('3'):
                    log.debug("Skipping Language Profile lookup because Sonarr version is \'%s\'.",
                              ver_resp_json['version'])
                    return None

        except Exception:
            log.exception("Exception verifying Sonarr version.")
            return None

        try:
            # make request
            req = requests.get(
                os.path.join(misc_str.ensure_endswith(self.server_url, "/"), 'api/v3/languageprofile'),
                headers=self.headers,
                timeout=60,
                allow_redirects=False
            )
            log.debug("Request URL: %s", req.url)
            log.debug("Request Response: %d", req.status_code)

            if req.status_code == 200:
                resp_json = req.json()
                for profile in resp_json:
                    if profile['name'].lower() == language_name.lower():
                        log.debug("Found Language Profile ID for \'%s\': %d", language_name, profile['id'])
                        return profile['id']
                    log.debug("Profile \'%s\' with ID \'%d\' did not match Language Profile \'%s\'", profile['name'],
                              profile['id'], language_name)
            else:
                log.error("Failed to retrieve all language profiles, request response: %d", req.status_code)
        except Exception:
            log.exception("Exception retrieving ID of language profile %s: ", language_name)
        return None

    def _prepare_add_object_payload(self, title, title_slug, quality_profile_id, root_folder):
        return {
            'title': title,
            'titleSlug': title_slug,
            'qualityProfileId': quality_profile_id,
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
                log.debug("Successfully added: \'%s [%d]\'", payload['title'], identifier)
                return True
            elif response_json and ('errorMessage' in response_json or 'message' in response_json):
                message = response_json['errorMessage'] if 'errorMessage' in response_json else response_json['message']

                log.error("Failed to add \'%s [%d]\' - status_code: %d, reason: %s", payload['title'], identifier,
                          req.status_code, message)
                return False
            else:
                log.error("Failed to add \'%s [%d]\', unexpected response:\n%s", payload['title'], identifier, req.text)
                return False
        except Exception:
            log.exception("Exception adding \'%s [%d]\': ", payload['title'], identifier)
        return None
