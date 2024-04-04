{#  If key is present then compare the rest of the data and if it is not the same then update else ignore. 
    If the key is not present then insert #}
    
{% macro scd1_hashkey_based_inc_load(information_schema_name,schema_name,table_name,tgt_schema_name,tgt_table_name) %}

{% set curr_timestamp_var %} ({{curr_timestamp_macro()}}) {% endset %}

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

{# update changed records #}
{% set sql_update_changed_records %}
update {{source(tgt_schema_name,tgt_table_name)}} t
set t.employee_name             = s.employee_name ,
    t.employee_salary           = s.employee_salary ,
    t.employee_department_id    = s.employee_department_id,
    t.etl_created_dt            = s.etl_created_dt ,
    t.etl_startdate             = s.etl_startdate ,
    t.etl_enddate               = s.etl_enddate ,
    t.etl_updated_at            = s.etl_updated_at ,
    t.etl_hashkey               = s.etl_hashkey ,
    t.etl_active_flg            = s.etl_active_flg
from ({{ stg_data }}) s
where (s.employee_id = t.employee_id and t.etl_hashkey <> s.etl_hashkey and t.etl_active_flg='Y')
{% endset %}
{% set rows_updated = run_query(sql_update_changed_records) %}

{# insert records #}
{% set sql_insert_new_records %}
insert into {{source(tgt_schema_name,tgt_table_name)}}
select      s.employee_id,
            s.employee_name ,
            s.employee_salary ,
            s.employee_department_id,
            s.etl_created_dt ,
            s.etl_startdate ,
            s.etl_enddate ,
            s.etl_updated_at ,
            s.etl_hashkey ,
            s.etl_active_flg
from        ({{ stg_data }}) s
left join   {{source(tgt_schema_name,tgt_table_name)}} t on s.employee_id = t.employee_id and t.etl_active_flg='Y'
where t.employee_id is null
{% endset %}
{% set rows_inserted = run_query(sql_insert_new_records) %}


{% endmacro %}