from os import (path, getenv)

from decouple import AutoConfig, Csv

# Scan ENV dir for config and fallback to current dir
config = AutoConfig(getenv('PLEX_PATROL_CONFIG', path.dirname(__file__)))

DEBUG = config('DEBUG', False, cast=bool)
LOGFILE = getenv('PLEX_PATROL_LOGFILE') or 'status.log'

SERVER_URL = config('SERVER_URL')
SERVER_TOKEN = config('SERVER_TOKEN')
SERVER_NAME = config('SERVER_NAME')
CHECK_INTERVAL = config('CHECK_INTERVAL', 60, cast=int)

KICK_VIDEO_TRANSCODES = config('KICK_VIDEO_TRANSCODES', False, cast=bool)
KICK_AUDIO_TRANSCODES = config('KICK_AUDIO_TRANSCODES', False, cast=bool)
KICK_CLIENT_PLAYERS = config('KICK_CLIENT_PLAYERS', [], cast=Csv())
KICK_MULTIPLE_IP = config('KICK_MULTIPLE_IP', False, cast=bool)
KICK_MULTIPLE_IP_MAX = config('KICK_MULTIPLE_IP_MAX', 1, cast=int)

KICK_PAUSED_TRANSCODES = config('KICK_PAUSED_TRANSCODES', False, cast=bool)
KICK_PAUSED_DIRECTPLAY = config('KICK_PAUSED_DIRECTPLAY', False, cast=bool)
KICK_PAUSED_GRACE_MINS = config('KICK_PAUSED_GRACE_MINS', 5, cast=int)

KICK_PAUSED_MESSAGE = config('KICK_PAUSED_MESSAGE', 'You are not allowed to pause a stream for that long... cya!')
KICK_TRANSCODE_MESSAGE = config('KICK_TRANSCODE_MESSAGE',
                                'You are not allowed to transcode streams, use a better client!')
KICK_PLAYER_MESSAGE = config('KICK_PLAYER_MESSAGE',
                             'You are not allowed to use this trash player. '
                             'Use the official software from www.plex.tv/downloads -> Get An App!!!')
KICK_MULTI_IP_MESSAGE = config('KICK_MULTI_IP_MESSAGE', 'You are not allowed to stream from more than 1 IP address!')

WHITELISTED_USERS = config('WHITELISTED_USERS', [], cast=Csv())
