
    
    

with dbt_test__target as (

  select id as unique_field
  from `key-polymer-434418-m6`.`airnow`.`my_second_dbt_model`
  where id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


