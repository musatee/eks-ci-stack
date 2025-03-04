from slack_sdk.errors import SlackApiError
from slack_sdk import WebClient 
import sys
username  = sys.argv[1] 
build_number = sys.argv[2] 
jenkins_job_name = sys.argv[3]
job_status = sys.argv[4]
slack_token = sys.argv[5]
channel = f"#{sys.argv[6]}"

message = f"Job Name: *{jenkins_job_name}*\nBuild Number: {build_number}\nStarted By: {username}\nJob Status: {job_status}"
client = WebClient(token = slack_token) 
try: 
    response = client.chat_postMessage(channel = channel, text = message) 
except SlackApiError as error: 
    print(f'Something went wrong: {error}')