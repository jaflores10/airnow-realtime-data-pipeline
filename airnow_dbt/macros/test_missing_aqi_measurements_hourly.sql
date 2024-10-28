/*** Missing AQI Measurements Test ***/
/**
The below test will identify where there is a missing AQI measurement in an hour within a day.
**/

{% macro test_missing_aqi_measurements_hourly(model) %}

{{ config(severity = 'warn')}}

WITH observations_count AS (
    SELECT
        DateObserved,
        HourObserved,
        COUNTIF(ParameterName = 'PM2.5') AS pm25_count,
        COUNTIF(ParameterName = 'PM10') AS pm10_count,
        COUNTIF(ParameterName IN ('O3', 'OZONE')) AS o3_count
    FROM {{ model }}
    GROUP BY
        1, 2
)

SELECT
    DateObserved,
    HourObserved,
    CASE
        WHEN pm25_count = 0 THEN 'PM2.5 is missing'
        WHEN pm10_count = 0 THEN 'PM10 is missing'
        WHEN o3_count = 0 THEN 'O3 is missing'
        ELSE 'All observations present'
    END AS missing_observation
FROM observations_count
WHERE
    pm25_count = 0 OR
    pm10_count = 0 OR
    o3_count = 0

{% endmacro %}