import functions_framework
import os
import smtplib
from email.message import EmailMessage
from google.cloud import bigquery

# Initialize BigQuery client
client = bigquery.Client()

# HTML template for the email form
HTML_FORM = """
<!doctype html>
<html>
<head><title>Air Quality Notification</title></head>
<body>
  <h2>Get Latest Air Quality Information for South Lake Tahoe, CA</h2>
  <form action="https://us-central1-key-polymer-434418-m6.cloudfunctions.net/airnow_email_notification" method="post">
    <label for="email">Enter your email:</label><br>
    <input type="email" id="email" name="email" required><br><br>
    <input type="submit" value="Get Air Quality Update">
  </form>
</body>
</html>
"""

# Function to get the latest air quality data
def get_latest_air_quality_info():
    query = """
    SELECT 
        DateObserved, 
        HourObserved,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        Latitude,
        Longitude,
        ParameterName,
        AQI,
        AQICategory,
        AQICategoryNumber
    FROM `key-polymer-434418-m6.airnow_analytics.airnow_realtime_analytics`
    WHERE ParameterName IN ('PM2.5', 'PM10', 'O3')
    ORDER BY DateObserved DESC, HourObserved DESC
    LIMIT 3
    """
    
    query_job = client.query(query)
    results = query_job.result()
    
    air_quality_data = {}
    for row in results:
        air_quality_data[row.ParameterName] = {
            'DateObserved': row.DateObserved,
            'HourObserved': row.HourObserved,
            'AQI': row.AQI,
            'AQICategory': row.AQICategory
        }
    
    return air_quality_data

# Function to send the air quality email
def send_air_quality_email(air_quality_info, recipient_email):
    email_user = os.getenv("EMAIL_USER")
    email_pass = os.getenv("EMAIL_PASS")
    
    # Prepare email content
    observation_date = list(air_quality_info.values())[0]['DateObserved'].strftime('%Y-%m-%d')
    observation_hour = list(air_quality_info.values())[0]['HourObserved']
    formatted_hour = f"{observation_hour:02d}:00"

    body = f"""
    Please see below for the latest air quality observations for South Lake Tahoe, CA.
    Observations as of {observation_date} {formatted_hour} PST:
    
    - PM2.5: {air_quality_info.get('PM2.5', {'AQICategory': 'Unavailable'})['AQICategory']}. AQI = {air_quality_info.get('PM2.5', {'AQI': 'Unavailable'})['AQI']}
    - PM10: {air_quality_info.get('PM10', {'AQICategory': 'Unavailable'})['AQICategory']}. AQI = {air_quality_info.get('PM10', {'AQI': 'Unavailable'})['AQI']}
    - O3: {air_quality_info.get('O3', {'AQICategory': 'Unavailable'})['AQICategory']}. AQI = {air_quality_info.get('O3', {'AQI': 'Unavailable'})['AQI']}
    """
    
    msg = EmailMessage()
    msg['Subject'] = 'Latest Air Quality Observations for South Lake Tahoe, CA'
    msg['From'] = email_user
    msg['To'] = recipient_email
    msg.set_content(body)

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login(email_user, email_pass)
        smtp.send_message(msg)


@functions_framework.http
def air_quality_notification(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """
    # Handle CORS preflight requests
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
        }
        return ('', 204, headers)

    headers = {
        'Access-Control-Allow-Origin': '*'
    }

    if request.method == 'POST':
        recipient_email = request.form['email']
        air_quality_data = get_latest_air_quality_info()
        
        if air_quality_data:
            send_air_quality_email(air_quality_data, recipient_email)
            return f"Air quality information sent to {recipient_email}.", 200, headers
        else:
            return "No air quality data found.", 404, headers

    # For GET requests, return the HTML form
    return HTML_FORM, 200, headers
