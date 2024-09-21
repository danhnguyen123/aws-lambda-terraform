"""
Purpose: Define logger for logging
"""
import logging
from config import config

log_level_map = {
    "debug": logging.DEBUG,
    "info": logging.INFO,
    "warn": logging.WARNING,
    "warning": logging.WARNING,
    "error": logging.ERROR,
    "critical": logging.CRITICAL,
    "fatal": logging.FATAL,
}

class LoggingHelper:

    def __init__(self, logger_name: str):
        self.logger_name = logger_name
        self._logger = self.get_configured_logger(self.logger_name)

    @staticmethod
    def get_configured_logger(logger_name):
        """
        Return a JSON logger to use

        :param logger_name: logger name
        :return: the logger
        """

        _handler = logging.StreamHandler()
        _logger = logging.getLogger(logger_name)
        # _logger.propagate = False
        _logger.addHandler(_handler)
        _logger.setLevel(log_level_map[config.LOG_LEVEL.lower()])
        return _logger
