select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      

WITH observations_count AS (
    SELECT
        DateObserved,
        HourObserved,
        COUNTIF(ParameterName = 'PM2.5') AS pm25_count,
        COUNTIF(ParameterName = 'PM10') AS pm10_count,
        COUNTIF(ParameterName IN ('O3', 'OZONE')) AS o3_count
    FROM `key-polymer-434418-m6`.`airnow_analytics`.`airnow_all_observations_analytics`
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


      
    ) dbt_internal_test