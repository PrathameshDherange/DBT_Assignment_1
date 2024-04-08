
with cte as ( 
    select * 
    from {{ source('snapshot','employee_details_snapshot') }} 
    )
, final as ( 
    select * 
    from cte 
    where dbt_valid_to is null 
    )
select * from final