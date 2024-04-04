{# if key is present then update else insert into target table #}
{% macro scd1_pk_based_inc_load(information_schema_name,schema_name,table_name) %}

{% set curr_timestamp_var %} ({{curr_timestamp_macro()}}) {% endset %}

with stg_data as (
    select *, 
        {{curr_timestamp_var}} as etl_startdate,
        '9999-12-31'::timestamp_ntz as etl_enddate,
        {{curr_timestamp_var}} as etl_updated_at, 
        {{generate_hashkey(information_schema_name,schema_name,table_name)}} as etl_hashkey, 
        'Y' as etl_active_flg
    from {{ source(schema_name,table_name) }}  s
    where   (etl_created_dt > (select max(etl_created_dt) from {{ this }} ))
            or employee_id not in (select employee_id from {{ this }})
    
    )
select * from stg_data

{% endmacro %}
