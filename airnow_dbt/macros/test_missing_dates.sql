/*** Missing Dates Test ***/
/**
The below test will may be used to identify whether the AirNow Historical Observations
tables has any missing dates between 2019-01-01 and 2024-09-01.
**/

{% macro test_missing_dates(model, column_name) %}

{{ config(severity = 'warn')}}

WITH date_range AS (
    -- Dynamically calculate the minimum and maximum dates in the data
    SELECT
        MIN(DATE({{ column_name }})) AS start_date,
        MAX(DATE({{ column_name }})) AS end_date
    FROM
        {{ model }}
),

date_spine AS (
    -- Generate a date spine based on the calculated start and end dates
    SELECT
        start_date + INTERVAL n DAY AS date_day
    FROM
        date_range,
        UNNEST(GENERATE_ARRAY(0, DATE_DIFF(end_date, start_date, DAY))) AS n
),

missing_dates AS (
    -- Find the missing dates by performing a LEFT JOIN between the date spine and the actual data
    SELECT
        ds.date_day
    FROM
        date_spine ds
    LEFT JOIN (
        SELECT DISTINCT DATE({{ column_name }}) AS date_day
        FROM {{ model }}
    ) AS model_dates
    ON ds.date_day = model_dates.date_day
    WHERE model_dates.date_day IS NULL
)

-- Return the missing dates
SELECT *
FROM missing_dates

{% endmacro %}