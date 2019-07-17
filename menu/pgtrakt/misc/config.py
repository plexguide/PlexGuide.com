import json
import os
import sys

from attrdict import AttrDict


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(
                Singleton, cls).__call__(*args, **kwargs)

        return cls._instances[cls]


class AttrConfig(AttrDict):
    """
    Simple AttrDict subclass to return None when requested attribute does not exist
    """

    def __init__(self, config):
        super().__init__(config)

    def __getattr__(self, item):
        try:
            return super().__getattr__(item)
        except AttributeError:
            pass
        # Default behaviour
        return None


class Config(object, metaclass=Singleton):
    base_config = {
        'core': {
            'debug': False
        },
        'trakt': {
            'client_id': '',
            'client_secret': ''
        },
        'sonarr': {
            'url': 'http://localhost:8989/',
            'api_key': '',
            'profile': 'HD-1080p',
            'root_folder': '/tv/',
            'tags': {
            }
        },
        'radarr': {
            'url': 'http://localhost:7878/',
            'api_key': '',
            'profile': 'HD-1080p',
            'root_folder': '/movies/'
        },
        'omdb': {
            'api_key': ''
        },
        'filters': {
            'shows': {
                'disabled_for': [],
                'blacklisted_genres': [],
                'blacklisted_networks': [],
                'allowed_countries': [],
                'allowed_languages': [],
                'blacklisted_min_runtime': 15,
                'blacklisted_min_year': 2000,
                'blacklisted_max_year': 2019,
                'blacklisted_tvdb_ids': [],
            },
            'movies': {
                'disabled_for': [],
                'blacklisted_genres': [],
                'blacklisted_min_runtime': 60,
                'blacklisted_min_year': 2000,
                'blacklisted_max_year': 2019,
                'blacklist_title_keywords': [],
                'blacklisted_tmdb_ids': [],
                'allowed_countries': [],
                'allowed_languages': [],
                'rating_limit': ""
            }
        },
        'automatic': {
            'movies': {
                'interval': 20,
                'anticipated': 3,
                'trending': 3,
                'popular': 3,
                'boxoffice': 10
            },
            'shows': {
                'interval': 48,
                'anticipated': 10,
                'trending': 1,
                'popular': 1
            }
        },
        'notifications': {
            'verbose': True
        }
    }

    def __init__(self, config_path, logfile):
        """Initializes config"""
        self.conf = None

        self.config_path = config_path
        self.log_path = logfile

    @property
    def cfg(self):
        # Return existing loaded config
        if self.conf:
            return self.conf

        # Built initial config if it doesn't exist
        if self.build_config():
            print("Please edit the default configuration before running again!")
            sys.exit(0)
        # Load config, upgrade if necessary
        else:
            tmp = self.load_config()
            self.conf, upgraded = self.upgrade_settings(tmp)

            # Save config if upgraded
            if upgraded:
                self.dump_config()
                print("New config options were added, adjust and restart!")
                sys.exit(0)

            return self.conf

    @property
    def logfile(self):
        return self.log_path

    def build_config(self):
        if not os.path.exists(self.config_path):
            print("Dumping default config to: %s" % self.config_path)
            with open(self.config_path, 'w') as fp:
                json.dump(self.base_config, fp, sort_keys=True, indent=2)
            return True
        else:
            return False

    def dump_config(self):
        if os.path.exists(self.config_path):
            with open(self.config_path, 'w') as fp:
                json.dump(self.conf, fp, sort_keys=True, indent=2)
            return True
        else:
            return False

    def load_config(self):
        with open(self.config_path, 'r') as fp:
            return AttrConfig(json.load(fp))

    def __inner_upgrade(self, settings1, settings2, key=None, overwrite=False):
        sub_upgraded = False
        merged = settings2.copy()

        if isinstance(settings1, dict):
            for k, v in settings1.items():
                # missing k
                if k not in settings2:
                    merged[k] = v
                    sub_upgraded = True
                    if not key:
                        print("Added %r config option: %s" % (str(k), str(v)))
                    else:
                        print("Added %r to config option %r: %s" %
                              (str(k), str(key), str(v)))
                    continue

                # iterate children
                if isinstance(v, dict) or isinstance(v, list):
                    merged[k], did_upgrade = self.__inner_upgrade(settings1[k], settings2[k], key=k,
                                                                  overwrite=overwrite)
                    sub_upgraded = did_upgrade if did_upgrade else sub_upgraded
                elif settings1[k] != settings2[k] and overwrite:
                    merged = settings1
                    sub_upgraded = True
        elif isinstance(settings1, list) and key:
            for v in settings1:
                if v not in settings2:
                    merged.append(v)
                    sub_upgraded = True
                    print("Added to config option %r: %s" % (str(key), str(v)))
                    continue

        return merged, sub_upgraded

    def upgrade_settings(self, currents):
        upgraded_settings, upgraded = self.__inner_upgrade(
            self.base_config, currents)
        return AttrConfig(upgraded_settings), upgraded

    def merge_settings(self, settings_to_merge):
        upgraded_settings, upgraded = self.__inner_upgrade(
            settings_to_merge, self.conf, overwrite=True)

        self.conf = upgraded_settings

        if upgraded:
            self.dump_config()

        return AttrConfig(upgraded_settings), upgraded
