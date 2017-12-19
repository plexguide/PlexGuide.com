#
# core.py
#
# Copyright (C) 2009 Chase Sterling <chase.sterling@gmail.com>
#
# Basic plugin template created by:
# Copyright (C) 2008 Martijn Voncken <mvoncken@gmail.com>
# Copyright (C) 2007-2009 Andrew Resch <andrewresch@gmail.com>
# Copyright (C) 2009 Damien Churchill <damoxc@gmail.com>
#
# Deluge is free software.
#
# You may redistribute it and/or modify it under the terms of the
# GNU General Public License, as published by the Free Software
# Foundation; either version 3 of the License, or (at your option)
# any later version.
#
# deluge is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with deluge.    If not, write to:
# 	The Free Software Foundation, Inc.,
# 	51 Franklin Street, Fifth Floor
# 	Boston, MA  02110-1301, USA.
#
#    In addition, as a special exception, the copyright holders give
#    permission to link the code of portions of this program with the OpenSSL
#    library.
#    You must obey the GNU General Public License in all respects for all of
#    the code used other than OpenSSL. If you modify file(s) with this
#    exception, you may extend this exception to your version of the file(s),
#    but you are not obligated to do so. If you do not wish to do so, delete
#    this exception statement from your version. If you delete this exception
#    statement from all source files in the program, then also delete it here.
#

import re
from twisted.internet.task import LoopingCall, deferLater
from twisted.internet import reactor
from deluge.log import LOG as log
from deluge.plugins.pluginbase import CorePluginBase
import deluge.component as component
import deluge.configmanager
from deluge.core.rpcserver import export

CONFIG_DEFAULT = {
    "default_stop_time": 7,
    "remove_torrent": False,
    "delay_time": 1,  # delay between adding torrent and setting initial seed time (in seconds)
    "filter_list": [], #example: {'field': 'tracker', 'filter': ".*", 'stop_time': 7.0}],
    "torrent_stop_times": {}  # torrent_id: stop_time (in hours)
}

class Core(CorePluginBase):

    #update_interval = 30

    def enable(self):
        self.config = deluge.configmanager.ConfigManager("seedtime.conf", CONFIG_DEFAULT)
        self.torrent_stop_times = self.config["torrent_stop_times"]
        self.delay_time = self.config["delay_time"]
        self.torrent_manager = component.get("TorrentManager")
        self.plugin = component.get("CorePluginManager")
        self.plugin.register_status_field("seed_stop_time", self._status_get_seed_stop_time)
        self.plugin.register_status_field("seed_time_remaining", self._status_get_remaining_seed_time)
        self.torrent_manager = component.get("TorrentManager")

        component.get("EventManager").register_event_handler("TorrentAddedEvent", self.post_torrent_add)
        component.get("EventManager").register_event_handler("TorrentRemovedEvent", self.post_torrent_remove)

        self.looping_call = LoopingCall(self.update_checker)
        deferLater(reactor, 5, self.start_looping)

    def start_looping(self):
        log.warning('seedtime loop starting')
        self.looping_call.start(10)

    def disable(self):
        self.plugin.deregister_status_field("seed_stop_time")
        self.plugin.deregister_status_field("seed_time_remaining")
        if self.looping_call.running:
            self.looping_call.stop()

    def update(self):
        pass

    def update_checker(self):
        """Check if any torrents have reached their stop seed time."""
        for torrent in component.get("Core").torrentmanager.torrents.values():
            if not (torrent.state == "Seeding" and torrent.torrent_id in self.torrent_stop_times):
                continue
            stop_time = self.torrent_stop_times[torrent.torrent_id]
            if torrent.get_status(['seeding_time'])['seeding_time'] > stop_time * 3600.0 * 24.0:
                if self.config['remove_torrent']:
                    self.torrent_manager.remove(torrent.torrent_id)
                else:
                    torrent.pause()

    ## Plugin hooks ##
    def post_torrent_add(self, torrent_id, from_state=None):
        if from_state == True or (from_state == None and not self.torrent_manager.session_started):
            return
        log.debug("seedtime post_torrent_add")

        # wait to apply initial seedtime filter
        # other plugins (i.e. label) need to run their post_torrent_add hooks first
        # or the user may wish to set the label before we apply the seed time filter
        deferLater(reactor, self.delay_time, self.apply_filter, torrent_id)

    def apply_filter(self, torrent_id):
        for filter_list in self.config['filter_list']:
            search_strs = None
            stop_time = None
            if filter_list['field'] == 'label':
                if 'Label' in component.get("CorePluginManager").get_enabled_plugins():
                    try:  # If label plugin changes and code no longer works, ignore this filter
                        # Can't seem to retrieve label from torrent manager so we must use the label plugin methods
                        # label_str = component.get("TorrentManager")[torrent_id].get_status(["label"])
                        label_str = component.get("CorePlugin.Label")._status_get_label(torrent_id)
                        if len(label_str) > 0:
                            search_strs = [label_str]
                    except:
                        log.debug('Cannot find torrent label')
            elif filter_list['field'] == 'tracker':
                torrent = component.get("TorrentManager")[torrent_id]
                trackers = torrent.get_status(["trackers"])["trackers"]
                search_strs = [tracker["url"] for tracker in trackers]
            elif filter_list['field'] == 'default':
                search_strs = ['']
            else:  # unknown filter, ignore
                pass

            if search_strs is not None:
                for search_str in search_strs:
                    if re.search(filter_list['filter'], search_str) is not None:
                        stop_time = filter_list['stop_time']
                        log.debug('filter %s matched %s %s' %
                                  (filter_list['filter'], filter_list['field'], search_str))
                if stop_time is not None:
                    log.debug('applying stop.... time %r' % stop_time)
                    self.set_torrent(torrent_id, stop_time)
                    break  # stop looking through filter list
        else: #apply default if no filters match
            stop_time = self.config['default_stop_time']
            if stop_time > 0:
                log.debug('applying stop.... time %r' % stop_time)
                self.set_torrent(torrent_id, stop_time)

    def post_torrent_remove(self, torrent_id):
        log.debug("seedtime post_torrent_remove")
        if torrent_id in self.torrent_stop_times:
            del self.torrent_stop_times[torrent_id]

    @export
    def set_config(self, config):
        """Sets the config dictionary"""
        log.debug('seedtime %r' % config)
        log.debug('component state %r, component timer %r' % (self._component_state, self._component_timer))
        for key in config.keys():
            self.config[key] = config[key]
        self.config.save()

    @export
    def get_config(self):
        """Returns the config dictionary"""
        return self.config.config

    @export
    def set_torrent(self, torrent_id , stop_time):
        if stop_time is None or stop_time < 0:
            del self.torrent_stop_times[torrent_id]
        else:
            self.torrent_stop_times[torrent_id] = stop_time
        self.config.save()

    def _status_get_seed_stop_time(self, torrent_id):
        """Returns the stop seed time for the torrent."""
        return self.torrent_stop_times.get(torrent_id, 0) * 3600.0 * 24.0

    def _status_get_remaining_seed_time(self, torrent_id):
        """Returns the stop seed time for the torrent."""
        stop_time = self._status_get_seed_stop_time(torrent_id)
        torrent = component.get("TorrentManager")[torrent_id]
        seed_time = torrent.get_status(['seeding_time'])['seeding_time']
        return max(0, stop_time-seed_time)
