from misc.log import logger

log = logger.get_logger(__name__)


def series_tag_id_from_network(profile_tags, network_tags, network):
    try:
        tags = []
        for tag_name, tag_networks in network_tags.items():
            for tag_network in tag_networks:
                if tag_network.lower() in network.lower() and tag_name.lower() in profile_tags:
                    log.debug("Using %s tag for network: %s",
                              tag_name, network)
                    tags.append(profile_tags[tag_name.lower()])
        if tags:
            return tags
    except Exception:
        log.exception(
            "Exception determining tag to use for network %s: ", network)
    return None


def readable_tag_from_ids(profile_tag_ids, chosen_tag_ids):
    try:
        if not chosen_tag_ids:
            return None

        tags = []
        for tag_name, tag_id in profile_tag_ids.items():
            if tag_id in chosen_tag_ids:
                tags.append(tag_name)
        if tags:
            return tags
    except Exception:
        log.exception(
            "Exception building readable tag name list from ids %s: ", chosen_tag_ids)
    return None


def series_to_tvdb_dict(sonarr_series):
    series = {}
    try:
        for tmp in sonarr_series:
            if 'tvdbId' not in tmp:
                log.debug("Could not handle show: %s", tmp['title'])
                continue
            series[tmp['tvdbId']] = tmp
        return series
    except Exception:
        log.exception("Exception processing Sonarr shows to TVDB dict: ")
    return None


def remove_existing_series(sonarr_series, trakt_series, callback=None):
    new_series_list = []

    if not sonarr_series or not trakt_series:
        log.error("Inappropriate parameters were supplied")
        return None

    try:
        # turn sonarr series result into a dict with tvdb id as keys
        processed_series = series_to_tvdb_dict(sonarr_series)
        if not processed_series:
            return None

        # loop list adding to series that do not already exist
        for tmp in trakt_series:
            if 'show' not in tmp or 'ids' not in tmp['show'] or 'tvdb' not in tmp['show']['ids']:
                log.debug(
                    "Skipping show because it did not have required fields: %s", tmp)
                if callback:
                    callback('show', tmp)
                continue
            # check if show exists in processed_series
            if tmp['show']['ids']['tvdb'] in processed_series:
                log.debug("Removing existing show: %s", tmp['show']['title'])
                if callback:
                    callback('show', tmp)
                continue

            new_series_list.append(tmp)

        log.debug("Filtered %d Trakt shows to %d shows that weren't already in Sonarr", len(trakt_series),
                  len(new_series_list))
        return new_series_list
    except Exception:
        log.exception("Exception removing existing shows from Trakt list: ")
    return None
