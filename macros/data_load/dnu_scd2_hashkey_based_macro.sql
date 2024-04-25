{# SCT Type 2 - comparing the rest of the data and making the decision of insert, update or ignore. #}

{% macro scd2_hashkey_based_macro(schema_name,table_name) %}

with stg_data_cte as (
    select  *
    from {{ ref("employee_details_snapshot_check") }} s
    )
select * from stg_data_cte
where dbt_valid_to is null

{% endmacro %}