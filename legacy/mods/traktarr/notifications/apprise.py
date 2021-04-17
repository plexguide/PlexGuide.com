import apprise

from misc.log import logger

log = logger.get_logger(__name__)


class Apprise:
    NAME = "Apprise"

    def __init__(self, url, title='Traktarr'):
        self.url = url
        self.title = title
        log.debug("Initialized Apprise notification agent")

    def send(self, **kwargs):
        if not self.url:
            log.error("You must specify a URL when initializing this class")
            return False

        # send notification
        try:
            apobj = apprise.Apprise()
            apobj.add(self.url)
            apobj.notify(
                title=self.title,
                body=kwargs['message'],
            )

        except Exception:
            log.exception("Error sending notification to %r", self.url)
        return False
