# Google Calendar CLI

A simple Command Line Interface for Google Calendar on Mac. Create Google Calendar events directly from your terminal!

## Setup

### 1. Create Google Apps Script

1. Go to [script.google.com](https://script.google.com)
2. Create a new project
3. Paste the code from `apps-script.js`
4. Run `testAuth` function to authorize
5. Deploy as Web App (Execute as: Me, Who has access: Anyone)
6. Copy the deployment URL

This step must be done to reproduce the tool on your own as you will need to access your own calendar. All code is provided in 'apps-script.js'.

### 2. Install the script

1. Copy `gcal.sh` to your home directory (or other folder)
2. Update `WEB_APP_URL` in the script with your deployment URL
3. Make it executable:
```bash
   chmod +x gcal.sh
```
4. Add alias to `~/.bash_profile` or `~/.zshrc`:
```bash
   alias gcal="~/gcal.sh"
   source ~/.bash_profile
```

## Usage
```bash
gcal <title> <calendar> <date> <start-time> <end-time> [description] [location]
```

### Examples
```bash
# Basic event on default calendar
gcal "Team Meeting" "" "2025-10-23" "10:00" "11:00"

# Event on specific calendar
gcal "Dentist" "Personal" "2025-10-24" "09:00" "10:00"

# With description and location
gcal "Lunch" "Personal" "2025-10-25" "12:00" "13:00" "Catch up" "Downtown Cafe"
```

### Arguments

- **title**: Event title (required)
- **calendar**: Calendar name or empty string "" for default (required)
- **date**: YYYY-MM-DD format (required)
- **start-time**: HH:MM format (required)
- **end-time**: HH:MM format (required)
- **description**: Optional description
- **location**: Optional location

## Requirements

- macOS
- Python 3
- Google Account
- Bash shell
