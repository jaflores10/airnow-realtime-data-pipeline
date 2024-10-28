/*** AirNow Real-time Observations Staging Model ***/
/**
The below model converts all columns, except for 'DataPulledAt' and 'DateObserved,' to the correct data type.
'DataPulledAt' and 'DateObserverd' are already TIMESTAMP data types.
**/

{{ config(
    materialized='table',
    schema='staging'
) }}

WITH airnow_realtime_source AS (
    SELECT * FROM {{ source('airnow_raw', 'airnow_raw_realtime') }}
),

airnow_realtime_update AS (
    SELECT
        *,
        CAST(HourObserved AS INT) AS HourObserved_update,
        CAST(Latitude AS DECIMAL) AS Latitude_update,
        CAST(Longitude AS DECIMAL) AS Longitude_update,
        CAST(AQI AS INT) AQI_update,
        JSON_EXTRACT_SCALAR(Category, '$.Name') AS AQICategory,
        CAST(JSON_EXTRACT_SCALAR(Category, '$.Number') AS INT) AS AQICategoryNumber
    FROM airnow_realtime_source
),

airnow_realtime_final AS (
    SELECT
        DateObserved,
        HourObserved_update AS HourObserved,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        AVG(Latitude_update) AS Latitude,
        AVG(Longitude_update) AS Longitude,
        ParameterName,
        AVG(AQI_update) AS AQI,
        AQICategory,
        AVG(AQICategoryNumber) AS AQICategoryNumber
    FROM airnow_realtime_update
    GROUP BY
        DateObserved,
        HourObserved_update,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        ParameterName,
        AQICategory
        
)

SELECT
    *
FROM airnow_realtime_final