{{ config(materialized='table') }}

with cte as ( 
    select {{generate_hashkey('RAW','EMPLOYEE_DETAILS')}} as etl_hashkey, * 
    from {{ source('raw','employee_details') }} s
    )
select * from cte