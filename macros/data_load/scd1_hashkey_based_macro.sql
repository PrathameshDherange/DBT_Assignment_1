{#  If key is present then compare the rest of the data and if it is not the same then update else ignore. 
    If the key is not present then insert #}
    
{% macro scd1_hashkey_based_macro(unique_key1,schema_name,table_name) %}

with src as (
    select  *, 
    {{ dbt_utils.generate_surrogate_key( ['employee_name','employee_salary','employee_department_id'] ) }} as hashkey
    from {{ source(schema_name,table_name) }} s
    {% if is_incremental() %}
    where s.etl_created_dt > (select coalesce(max(t.etl_created_dt),'1790-01-01') from {{ this }} t)
    or s.{{unique_key1}} not in (select t.{{unique_key1}} from {{ this }} t)
    {% endif %}
    )

, tgt as (
    select *, 
    {{ dbt_utils.generate_surrogate_key( ['employee_name','employee_salary','employee_department_id'] ) }} as hashkey
    from {{ this }}
)

select src.*
from src
left join tgt on src.{{unique_key1}}=tgt.{{unique_key1}}
where src.hashkey<>tgt.hashkey or tgt.{{unique_key1}} is null


{% endmacro %}