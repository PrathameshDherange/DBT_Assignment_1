{# SCD Type 1 - if key is present then update else insert into target table. #}

{{ config(materialized='incremental', unique_key = 'employee_id') }}

with cte as ( select * from {{ source('raw','employee_details') }} )

select * from cte

{% if is_incremental() %}

where   (last_modified_timestamp > (select max(last_modified_timestamp) from {{ this }} ))
        or employee_id not in (select employee_id from {{ this }})

{% endif %}