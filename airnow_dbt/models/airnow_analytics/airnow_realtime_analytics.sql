/*** AirNow Real-time Analytics Model ***/
/**
Model selects everything from the 'airnow_realtime_staging' table. This model/table will serve as the data source for the air quality notification script.
**/

{{ config(
    materialized='table',
    schema='analytics'
) }}

WITH airnow_realtime_source AS (
    SELECT * FROM {{ ref('airnow_realtime_stage') }}
)

SELECT * FROM airnow_realtime_source