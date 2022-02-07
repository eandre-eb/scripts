from csv import reader
import requests
from requests.auth import HTTPBasicAuth
import json
​
def create_ticket(row):
​
    url = 'https://eventbrite.atlassian.net/rest/api/3/issue'
​
    auth = HTTPBasicAuth('emiliano@eventbrite.com', '')
​
    headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
    }
​
    summary = 'Update ' + row[12] + ' to be supported in Python 3'
    description = summary + ', the current version is ' + row[13] + '. And the link to pypi is ' + row[14]
​
    # Calculate Story Point Size
    size = 0
    if (row[4] == 'XS') :
        size = 0.5
    elif (row[4] == 'S') :
        size = 3
    elif (row[4] == 'M') :
        size = 5
    elif (row[4] == 'L') :
        size = 7
    elif (row[4] == 'XL') :
        size = 14
    elif (row[4] == 'XXL') :
        size = 20
​
    payload = json.dumps( {
        'update': {},
        'fields': {
            'summary': summary,
            'issuetype': {
            'id': '3'
            },
            'project': {
              'id': '10575'
            },
            'description': {
            'type': 'doc',
            'version': 1,
            'content': [
                {
                'type': 'paragraph',
                'content': [
                    {
                    'text': description,
                    'type': 'text'
                    }
                ]
                }
            ]
            },
            'customfield_10847': {
            'self': 'https://eventbrite.atlassian.net/rest/api/3/customFieldOption/15626',
            'value': 'Zordon',
            'id': '15626',
            },
            'labels': [
            'python3_upgrade',
            ],
            'customfield_10540': 'EB-146478',
            'customfield_10003': size,
            'timetracking': {
                'originalEstimate': str(size) + 'd'
            },
            'fixVersions': [
                {
                'id': '18217',
            }
            ]
        }
    } )
​
    response = requests.request(
        'POST',
        url,
        data=payload,
        headers=headers,
        auth=auth
    )
​
    print(json.dumps(json.loads(response.text), sort_keys=True, indent=4, separators=(',', ': ')))
​
​
with open('/Users/emiliano/eventbrite/devtools/scripts/jira/dependencies.csv', 'r') as read_obj:
    csv_reader = reader(read_obj)
    header = next(csv_reader)
    
    # Check if file is empty
    if header != None:
        # Iterate over each row after the header in the csv
        for row in csv_reader:
            create_ticket(row)
