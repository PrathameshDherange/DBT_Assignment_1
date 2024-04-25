{# if key is present then update else insert into target table #}
{% macro scd1_key_based_macro(unique_key1,schema_name,table_name) %}

with src as (
    select * from {{ source(schema_name,table_name) }}  s
    )

select * from src s
{% if is_incremental() %}
    where s.etl_created_dt > (select coalesce(max(t.etl_created_dt),'1790-01-01') from {{ this }} t)
    or s.{{unique_key1}} not in (select t.{{unique_key1}} from {{ this }} t)
{% endif %}

{% endmacro %}
