

  create or replace view `key-polymer-434418-m6`.`airnow_raw`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `key-polymer-434418-m6`.`airnow_raw`.`my_first_dbt_model`
where id = 1;

