import json

from sqlitedict import SqliteDict


class Cache:
    def __init__(self, cache_file_path):
        self.cache_file_path = cache_file_path
        self.caches = {}

    def get_cache(self, cache_name, autocommit=False):
        if cache_name not in self.caches:
            self.caches[cache_name] = SqliteDict(self.cache_file_path, tablename=cache_name, encode=json.dumps,
                                                 decode=json.loads, autocommit=autocommit)
        return self.caches[cache_name]
