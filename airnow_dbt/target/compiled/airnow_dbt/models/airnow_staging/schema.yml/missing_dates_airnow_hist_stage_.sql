

WITH date_spine AS (
    SELECT * FROM `key-polymer-434418-m6`.`airnow_airnow_staging`.`date_spine`
),

hist_observation_dates AS (
    SELECT
        DISTINCT DATE(DateObserved) AS date_day
    FROM `key-polymer-434418-m6`.`airnow_staging`.`airnow_hist_stage`
)

SELECT
    date_spine.date_day
FROM
    date_spine
LEFT JOIN
    hist_observation_dates ON date_spine.date_day = hist_observation_dates.date_day
WHERE
    hist_observation_dates.date_day IS NULL

