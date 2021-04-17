import logging
import os
import sys
from logging.handlers import RotatingFileHandler

from misc.config import Config


class Logger:
    def __init__(self, file_name=None, log_level=logging.DEBUG,
                 log_format='%(asctime)s - %(levelname)-10s - %(name)-35s - %(funcName)-35s - %(message)s'):
        self.log_format = log_format

        # init root_logger
        self.log_formatter = logging.Formatter(log_format)
        self.root_logger = logging.getLogger()
        self.root_logger.setLevel(log_level)

        # disable bloat loggers
        logging.getLogger("requests").setLevel(logging.WARNING)
        logging.getLogger('urllib3').setLevel(logging.ERROR)
        logging.getLogger('schedule').setLevel(logging.ERROR)

        # init console_logger
        self.console_handler = logging.StreamHandler(sys.stdout)
        self.console_handler.setFormatter(self.log_formatter)
        self.root_logger.addHandler(self.console_handler)

        # init file_logger
        if file_name:
            if os.path.sep not in file_name:
                # file_name was a filename, lets build a full file_path
                self.log_file_path = os.path.join(os.path.dirname(os.path.realpath(sys.argv[0])), file_name)
            else:
                self.log_file_path = file_name

            self.file_handler = RotatingFileHandler(
                self.log_file_path,
                maxBytes=1024 * 1024 * 5,
                backupCount=5
            )
            self.file_handler.setFormatter(self.log_formatter)
            self.root_logger.addHandler(self.file_handler)

        # Set chosen logging level
        self.root_logger.setLevel(log_level)

    def get_logger(self, name):
        return self.root_logger.getChild(name)


# Default logger
logger = Logger(Config().logfile, logging.DEBUG if Config().cfg.core.debug else logging.INFO)
