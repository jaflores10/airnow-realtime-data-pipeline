

  create or replace view `key-polymer-434418-m6`.`airnow_test`.`date_spine`
  OPTIONS()
  as /*** Date Spine Table ***/
/** This table will be used to create a list of dates between 2019-01-01 and
2024-09-01.'
**/



SELECT
    date_day
FROM
    UNNEST(GENERATE_DATE_ARRAY('2019-01-01', '2024-09-01', INTERVAL 1 DAY)) AS date_day;

