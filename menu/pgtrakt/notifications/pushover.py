import requests

from misc.log import logger

log = logger.get_logger(__name__)


class Pushover:
    NAME = "Pushover"

    def __init__(self, app_token, user_token, priority=0):
        self.app_token = app_token
        self.user_token = user_token
        self.priority = priority
        log.debug("Initialized Pushover notification agent")

    def send(self, **kwargs):
        if not self.app_token or not self.user_token:
            log.error("You must specify an app_token and user_token when initializing this class")
            return False

        # send notification
        try:
            payload = {
                'token': self.app_token,
                'user': self.user_token,
                'message': kwargs['message'],
                'priority': self.priority,
            }
            resp = requests.post('https://api.pushover.net/1/messages.json', data=payload, timeout=30)
            return True if resp.status_code == 200 else False

        except Exception:
            log.exception("Error sending notification to %r", self.user_token)
        return False
