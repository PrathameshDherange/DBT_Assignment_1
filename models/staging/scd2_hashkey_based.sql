{# SCT Type 2 - comparing the rest of the data and making the decision of insert, update or ignore. uniquekey/tags/ #}

{{ config(
    materialized='incremental', 
    incremental_strategy='merge',
    unique_key='employee_id',
    tags=["scd2","emp_load"]
    ) 
}}
with stg_data_cte as (
    select  *
    from {{ ref("employee_details_snapshot_check") }} s
    )
select * from stg_data_cte
where dbt_valid_to is null