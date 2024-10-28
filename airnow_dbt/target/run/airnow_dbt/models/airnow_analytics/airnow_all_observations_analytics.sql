
  
    

    create or replace table `key-polymer-434418-m6`.`airnow_analytics`.`airnow_all_observations_analytics`
      
    
    

    OPTIONS()
    as (
      /*** AirNow All Observations (Historical and Real-time) ***/
/**
Model UNIONs together historical and real-time AirNow observations. Real-time observations are averaged by day. 'HourObserved' column left out as data is at the day level.
**/



WITH airnow_hist_source AS (
    SELECT * FROM `key-polymer-434418-m6`.`airnow_staging`.`airnow_hist_stage`
),

airnow_realtime_source AS (
    SELECT * FROM `key-polymer-434418-m6`.`airnow_staging`.`airnow_realtime_stage`
),

airnow_hist_agg AS (
    SELECT
        DateObserved,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        MIN(Latitude) AS Latitude,
        MIN(Longitude) AS Longitude,
        CASE
            WHEN ParameterName = 'OZONE' THEN 'O3'
            ELSE ParameterName
        END AS ParameterName,
        ROUND(AVG(AQI)) AS AQI,
        MIN(AQICategory) AS AQICategory,
        ROUND(AVG(AQICategoryNumber)) AS AQICategoryNumber
    FROM airnow_hist_source
    GROUP BY
        DateObserved,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        ParameterName

),

airnow_realtime_agg AS (
    SELECT
        DateObserved,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        MIN(Latitude) AS Latitude,
        MIN(Longitude) AS Longitude,
        ParameterName,
        ROUND(AVG(AQI)) AS AQI,
        MIN(AQICategory) AS AQICategory,
        ROUND(AVG(AQICategoryNumber)) AS AQICategoryNumber
    FROM airnow_realtime_source
    GROUP BY
        DateObserved,
        LocalTimeZone,
        ReportingArea,
        StateCode,
        ParameterName
),

airnow_all_observations_final AS (
    SELECT * FROM airnow_hist_agg
    UNION All
    SELECT * FROM airnow_realtime_agg
)


SELECT * FROM airnow_all_observations_final
    );
  