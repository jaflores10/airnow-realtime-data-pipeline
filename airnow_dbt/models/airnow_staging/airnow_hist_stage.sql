/*** AirNow Historical Observations Staging Model ***/
/**
The below model converts all columns, except for 'DateObserved,' to the correct data type. 'DateObserved' is already
a TIMESTAMP data type.
**/

{{ config(
    materialized='table',
    schema='staging'
) }}

WITH airnow_hist_source AS (
    SELECT * FROM {{ source('airnow_raw', 'airnow_hist_raw') }}
),

airnow_hist_update AS (
    SELECT
        *,
        CAST(HourObserved AS INT) AS HourObserved_update,
        CAST(Latitude AS DECIMAL) AS Latitude_update,
        CAST(Longitude AS DECIMAL) AS Longitude_update,
        CAST(AQI AS INT) AQI_update,
        JSON_EXTRACT_SCALAR(Category, '$.Name') AS AQICategory,
        CAST(JSON_EXTRACT_SCALAR(Category, '$.Number') AS INT) AS AQICategoryNumber
    FROM airnow_hist_source
),

airnow_hist_final AS (
    SELECT
        DateObserved,
        HourObserved_update AS HourObserved,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        Latitude_update AS Latitude,
        Longitude_update AS Longitude,
        ParameterName,
        AQI_update AS AQI,
        AQICategory,
        AQICategoryNumber
    FROM airnow_hist_update
)

SELECT 
    * 
FROM airnow_hist_final