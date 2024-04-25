{# SCT Type 2 - comparing the rest of the data and making the decision of insert, update or ignore. #}

{% macro scd2_w_hashkey_test(information_schema_name,schema_name,table_name,tgt_schema_name,tgt_table_name) %}

{# set current timestamp #}
{% set curr_timestamp_var %} ({{curr_timestamp_macro()}}) {% endset %}

{# get stage data #}
{% set stg_data %}
with stg_data_cte as (
    select  *,
            {{curr_timestamp_var}} as etl_startdate,
            '9999-12-31'::timestamp_ntz as etl_enddate,
            {{curr_timestamp_var}} as etl_updated_at,
            {{generate_hashkey(information_schema_name,schema_name,table_name)}} as etl_hashkey,
            'Y' as etl_active_flg
    from {{ source(schema_name,table_name) }} s
    where (etl_created_dt > (select max(etl_created_dt) from {{ this }} ))
            or employee_id not in (select employee_id from {{ this }})
    )
select * from stg_data_cte
{% endset %}    

{# Update existing records against Changed records #}
{% set sql_update_changed_records %}
update {{source(tgt_schema_name,tgt_table_name)}} t
set etl_enddate= {{curr_timestamp_var}},
    etl_active_flg='N'
where etl_active_flg='Y' and
    t.employee_id in (
    select      t.employee_id 
    from        {{source(tgt_schema_name,tgt_table_name)}} t
    inner join  ({{ stg_data }})  s on t.employee_id=s.employee_id and t.etl_active_flg='Y'
    where       t.etl_hashkey<> s.etl_hashkey             
    ) 
{% endset %}
{% set rows_updated = run_query(sql_update_changed_records) %}

{# query to get target column list#}
{% set tgt_col %} 
select column_name from {{source(information_schema_name,'columns')}}
where lower(table_schema)='{{tgt_schema_name}}' and lower(table_name)='{{tgt_table_name}}'
order by ordinal_position
{% endset %}

{# execute above query #}
{% set run_tgt_cols = run_query(tgt_col) %}

{# store column list #}
{% if execute %}
{% set result_tgt_col = run_tgt_cols.columns[0].values() %}
{% else %}
{% set result_tgt_col = [] %}
{% endif %}

{# insert changed and new records #}
{% set sql_insert_new_and_changed_records %}
insert into {{ source(tgt_schema_name,tgt_table_name) }}
select     
    {% for col_name in result_tgt_col %}
        s.{{col_name}}
        {%- if not loop.last -%} , {%- endif -%}
    {% endfor %}
from        ( {{stg_data}} ) s
left join   {{ source(tgt_schema_name,tgt_table_name) }} t on s.employee_id=t.employee_id and t.etl_active_flg='Y'
where       t.employee_id is null
{% endset %}

{% set rows_inserted = run_query(sql_insert_new_and_changed_records) %}

{% endmacro %}