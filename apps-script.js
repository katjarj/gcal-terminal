function doGet(e) {
  return ContentService.createTextOutput(JSON.stringify({
    success: false,
    error: 'This endpoint only accepts POST requests. Use the terminal script to create events.'
  })).setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  try {
    var data = JSON.parse(e.postData.contents);
    
    // Get calendar by name, or use default if not specified
    var calendar;
    if (data.calendar && data.calendar.trim() !== '') {
      var calendars = CalendarApp.getCalendarsByName(data.calendar);
      if (calendars.length > 0) {
        calendar = calendars[0];
      } else {
        return ContentService.createTextOutput(JSON.stringify({
          success: false,
          error: 'Calendar "' + data.calendar + '" not found'
        })).setMimeType(ContentService.MimeType.JSON);
      }
    } else {
      calendar = CalendarApp.getDefaultCalendar();
    }
    
    var startTime = new Date(data.startTime);
    var endTime = new Date(data.endTime);
    
    var event = calendar.createEvent(
      data.title,
      startTime,
      endTime,
      {
        description: data.description || '',
        location: data.location || ''
      }
    );
    
    return ContentService.createTextOutput(JSON.stringify({
      success: true,
      eventId: event.getId(),
      calendar: calendar.getName(),
      message: 'Event created successfully'
    })).setMimeType(ContentService.MimeType.JSON);
    
  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({
      success: false,
      error: error.toString()
    })).setMimeType(ContentService.MimeType.JSON);
  }
}

function testAuth() {
  var calendar = CalendarApp.getDefaultCalendar();
  Logger.log("Calendar: " + calendar.getName());
}
