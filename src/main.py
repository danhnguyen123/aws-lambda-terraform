import boto3
import requests

def main(event, context):
    # TODO implement
    print(event)
    print(context)
    print("Hello world")
    print(f"Version of requests library: {requests.__version__}")
    request = requests.get('https://api.github.com/')
    return {
        'statusCode': request.status_code,
        'body': request.text
    }