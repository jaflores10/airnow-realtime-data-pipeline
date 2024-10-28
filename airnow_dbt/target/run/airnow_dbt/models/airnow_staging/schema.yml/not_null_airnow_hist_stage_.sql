select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select 
from `key-polymer-434418-m6`.`airnow_staging`.`airnow_hist_stage`
where  is null



      
    ) dbt_internal_test