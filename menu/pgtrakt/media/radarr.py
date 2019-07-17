import backoff

from helpers.misc import backoff_handler, dict_merge
from media.pvr import PVR
from misc.log import logger

log = logger.get_logger(__name__)


class Radarr(PVR):
    def get_objects(self):
        return self._get_objects('api/movie')

    @backoff.on_predicate(backoff.expo, lambda x: x is None, max_tries=4, on_backoff=backoff_handler)
    def add_movie(self, movie_tmdbid, movie_title, movie_year, movie_title_slug, profile_id, root_folder,
                  search_missing=False):
        payload = self._prepare_add_object_payload(
            movie_title, movie_title_slug, profile_id, root_folder)

        payload = dict_merge(payload, {
            'tmdbId': movie_tmdbid,
            'year': movie_year,
            'minimumAvailability': 'released',
            'addOptions': {
                'searchForMovie': search_missing
            }
        })

        return self._add_object('api/movie', payload, identifier_field='tmdbId', identifier=movie_tmdbid)
