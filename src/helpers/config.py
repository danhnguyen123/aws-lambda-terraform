import os
class AppConfig(object):
    """
    Access environment variables here.
    """
    def __init__(self):
        """
        Load env
        """

    LOG_LEVEL = os.getenv("LOG_LEVEL","DEBUG")
    SERVICE_NAME = os.getenv("SERVICE_NAME","unkonw")
    SNS_ARN = os.getenv("SNS_ARN","unkonw")


config = AppConfig()
