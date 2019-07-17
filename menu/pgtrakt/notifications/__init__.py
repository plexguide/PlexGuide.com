from misc.log import logger

from .pushover import Pushover
from .slack import Slack

log = logger.get_logger(__name__)

SERVICES = {
    'pushover': Pushover,
    'slack': Slack
}


class Notifications:
    def __init__(self):
        self.services = []

    def load(self, **kwargs):
        if 'service' not in kwargs:
            log.error(
                "You must specify a service to load with the service parameter")
            return False
        elif kwargs['service'] not in SERVICES:
            log.error("You specified an invalid service to load: %s",
                      kwargs['service'])
            return False

        try:
            chosen_service = SERVICES[kwargs['service']]
            del kwargs['service']

            # load service
            service = chosen_service(**kwargs)
            self.services.append(service)

        except Exception:
            log.exception(
                "Exception while loading service, kwargs=%r: ", kwargs)

    def send(self, **kwargs):
        try:
            # remove service keyword if supplied
            if 'service' in kwargs:
                # send notification to specified service
                chosen_service = kwargs['service'].lower()
                del kwargs['service']
            else:
                chosen_service = None

            # send notification(s)
            for service in self.services:
                if chosen_service and service.NAME.lower() != chosen_service:
                    continue
                elif service.send(**kwargs):
                    log.debug("Sent notification with %s", service.NAME)
        except Exception:
            log.exception(
                "Exception sending notification, kwargs=%r: ", kwargs)
