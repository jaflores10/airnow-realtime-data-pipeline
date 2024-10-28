{% docs airnow_hist_raw %}

The 'airnow_hist_raw' table contains historical air quality data for South Lake Tahoe, CA. Date range of data is 2019-01-01 to 2024-09-01. All columns in the raw data are VARCHAR except for DateObserved. DateObserved is a timestamp data type.

Columns:
- DateObserved: date of air quality observation.
- HourObserved: hour within the date of the air quality observation. All 0 as historical observations only provide an average for a given day.
- LocalTimeZone: Returns timezone of the relevant zip code.
- ReportingArea: City/town of the relevant zip code.
- StateCode: State of the relevant zip code.
- Latitude: Latitude of the relevant zip code.
- Longitude: Longitude of the relevant zip code.
- ParameterName: Air quality unit measurement (API returns PM2.5, PM10, and OZONE).
- AQI: Air Quality Index. Scale is 0-500. Each measurement uses the same scale.
- Category: Provides description for AQI as follows:
    - AQI 0-50: AQI Category = Good; Category Number = 1
    - AQI 51-100: AQI Category = Moderate; Category Number = 2
    - AQI 101-150: AQI Category = Unhealthy for Sensitive Groups; Category Number = 3
    - AQI 151-200: AQI Category = Unhealthy; Category Number = 4
    - AQI 201-300: AQI Category = Very Unhealthy; Category Number = 5
    - AQI 301-500: AQI Category = Hazardous; Category Number = 6

{% enddocs %}

{% docs airnow_raw_realtime %}

The 'airnow_raw_realtime' table contains real-time air quality data for South Lake Tahoe, CA. All columns in the real-tiem data are VARCHAR except for DataPulledAt and DateObserved. DataPulledAt and DateObserved are timestamp data types.

Columns:
- DataPulledAt: UTC time of when the automated python script made an API call.
- DateObserved: date of air quality observation.
- Hour Observed: hour within the date of the air quality observation. All 0 as historical observations only provide an average for a given day.
- LocalTimeZone: Returns timezone of the relevant zip code.
- Reporting Area: City/town of the relevant zip code.
- StateCode: State of the relevant zip code.
- Latitude: Latitude of the relevant zip code.
- Longitude: Longitude of the relevant zip code.
- ParameterName: Air Quality unit measurement (API returns PM2.5, PM10, and OZONE).
- AQI: Air Quality Index. Scale is 0-500. Each measurement uses the same scale.
- Category: Provides description for AQI as follows:
    - AQI 0-50: AQI Category = Good; Category Number = 1
    - AQI 51-100: AQI Category = Moderate; Category Number = 2
    - AQI 101-150: AQI Category = Unhealthy for Sensitive Groups; Category Number = 3
    - AQI 151-200: AQI Category = Unhealthy; Category Number = 4
    - AQI 201-300: AQI Category = Very Unhealthy; Category Number = 5
    - AQI 301-500: AQI Category = Hazardous; Category Number = 6

{% enddocs %}