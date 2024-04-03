{# Append mode when key is not found - insert only if key is not present in target table. #}

{{ config(materialized='incremental') }}

with cte as ( select * from {{ source('raw','employee_details') }} )

select * from cte

{% if is_incremental() %}
where last_modified_timestamp > ( select max(last_modified_timestamp) from {{ this }})
and employee_id not in (select employee_id from {{ this }})
{% endif %}