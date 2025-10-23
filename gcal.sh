#!/bin/bash

# Your Google Apps Script web app URL
WEB_APP_URL="YOUR_DEPLOYMENT_URL_HERE"

# Function to create a calendar event
create_event() {
    local title="$1"
    local calendar="${2:-}"
    local date="$3"
    local start_time="$4"
    local end_time="$5"
    local description="${6:-}"
    local location="${7:-}"
    
    # Add :00 seconds if not present
    [[ ! "$start_time" =~ :[0-9]{2}$ ]] && start_time="${start_time}:00"
    [[ ! "$end_time" =~ :[0-9]{2}$ ]] && end_time="${end_time}:00"
    
    # Combine date and time into ISO format
    local start="${date}T${start_time}"
    local end="${date}T${end_time}"
    
    # Use Python to make the request (handles redirects properly)
    response=$(python3 -c "
import json
import urllib.request
import ssl

# Disable SSL verification
ssl_context = ssl._create_unverified_context()

url = '$WEB_APP_URL'
data = {
    'title': '''$title''',
    'startTime': '$start',
    'endTime': '$end',
    'calendar': '$calendar',
    'description': '$description',
    'location': '$location'
}

req = urllib.request.Request(url, 
    data=json.dumps(data).encode('utf-8'),
    headers={'Content-Type': 'application/json'})

try:
    with urllib.request.urlopen(req, context=ssl_context) as response:
        print(response.read().decode('utf-8'))
except Exception as e:
    print(json.dumps({'success': False, 'error': str(e)}))
")
    
    # Parse and display clean output
    if echo "$response" | grep -q '"success".*true'; then
        echo "Event created: $title"
        echo "Date: $date from $start_time to $end_time"
        [ -n "$calendar" ] && echo "Calendar: $calendar"
        [ -n "$location" ] && echo "Location: $location"
    else
        echo "Error creating event"
        echo "$response"
    fi
}

# Show usage if no arguments
if [ $# -lt 4 ]; then
    echo "Usage: gcal <title> <calendar> <date> <start-time> <end-time> [description] [location]"
    echo ""
    echo "Example:"
    echo "  gcal 'Team Meeting' 'Work' '2025-10-23' '10:00' '11:00'"
    echo "  gcal 'Test' '' '2025-10-23' '14:00' '15:00'"
    exit 1
fi

# Call the function with arguments
create_event "$1" "$2" "$3" "$4" "$5" "$6" "$7"
