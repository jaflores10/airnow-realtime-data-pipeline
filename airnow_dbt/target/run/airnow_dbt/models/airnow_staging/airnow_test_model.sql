

  create or replace view `key-polymer-434418-m6`.`airnow_raw_staging`.`airnow_test_model`
  OPTIONS()
  as 

WITH hist_test AS (
    SELECT * FROM `key-polymer-434418-m6`.`airnow_raw`.`airnow_hist_raw`
)

SELECT * FROM hist_test;

