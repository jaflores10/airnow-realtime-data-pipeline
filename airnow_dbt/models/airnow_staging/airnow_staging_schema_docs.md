{% docs DataPulledAt %}
The 'DataPulledAt' column holds the UTC time of when the automated python script made an API call for the 'airnow_raw_realtime' table.
{% enddocs %}

{% docs DateObserved %}
- The 'DateObserved' column holds the date of the air quality observation.
- Data type: TIMESTAMP
{% enddocs %}

{% docs HourObserved %}
- The 'HourObserved' column holds the hour within the date of the air quality observation. All historical data has 0 given historical observations are an average of AQI measurements.
- Data type: INT
{% enddocs %}

{% docs LocalTimeZone %}
- The 'LocalTimeZone' column holds the timezone of the relevant zip code.
- Data type: VARCHAR
{% enddocs %}

{% docs ReportingArea %}
- The 'ReportingArea' column holds the city/town of the relevant zip code.
- Data type: VARCHAR
{% enddocs %}

{% docs StateCode %}
- The 'StateCode' column holds the state of the relevant zip code.
- Data type: VARCHAR
{% enddocs %}

{% docs Latitude %}
- Latitude of the relevant zip code.
- Data type: FLOAT
{% enddocs %}

{% docs Longitude %}
- Longitude of the relevant zip code.
- Data type: FLOAT
{% enddocs %}

{% docs ParameterName %}
- The 'ParameterName' holds the air quality unit measurement (API returns PM2.5, PM10, and OZONE)
- Data type: VARCHAR
{% enddocs %}

{% docs AQI %}
- The 'AQI' column holds the Air Quality Index value. Scale is 0-500. Each measurement in ParameterName uses the same scale.
- Data type: INT
{% enddocs %}

{% docs AQICategory %}
- The 'AQICategory' column holds the category for a given observation. Categories are as follows:
    - AQI 0-50: Good
    - AQI 51-100: Moderate
    - AQI 101-150: Unhealthy for Sensitive Groups
    - AQI 151-200: Unhealthy
    - AQI 201-300: Very Unhealthy
    - AQI 301-500: Hazardous
- Data type: VARCHAR
{% enddocs %}

{% docs AQICategoryNumber %}
- The 'AQICategoryNumber' column holds the number associated with the AQI categories as follows:
    - Good = 1
    - Moderate = 2
    - Unhealthy for Sensitive Groups = 3
    - Unhealthy = 4
    - Very Unhealthy = 5
    - Hazardous = 6
- Data type: INT
{% enddocs %}