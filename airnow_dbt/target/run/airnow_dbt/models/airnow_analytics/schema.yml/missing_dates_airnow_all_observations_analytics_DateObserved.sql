select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      

WITH date_range AS (
    -- Dynamically calculate the minimum and maximum dates in the data
    SELECT
        MIN(DATE(DateObserved)) AS start_date,
        MAX(DATE(DateObserved)) AS end_date
    FROM
        `key-polymer-434418-m6`.`airnow_analytics`.`airnow_all_observations_analytics`
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
        SELECT DISTINCT DATE(DateObserved) AS date_day
        FROM `key-polymer-434418-m6`.`airnow_analytics`.`airnow_all_observations_analytics`
    ) AS model_dates
    ON ds.date_day = model_dates.date_day
    WHERE model_dates.date_day IS NULL
)

-- Return the missing dates
SELECT *
FROM missing_dates


      
    ) dbt_internal_test