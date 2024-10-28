/*** AirNow Real-time Analytics Model ***/
/**
Model selects everything from the 'airnow_realtime_staging' table. This model/table will serve as the data source for the air quality notification script.
**/



WITH airnow_realtime_source AS (
    SELECT * FROM `key-polymer-434418-m6`.`airnow_staging`.`airnow_realtime_stage`
)

SELECT * FROM airnow_realtime_source