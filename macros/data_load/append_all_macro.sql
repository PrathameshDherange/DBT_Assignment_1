{# Append mode - whatever is coming from source, insert to target table #}

{% macro append_all_macro(schema_name,table_name) %}

with src as ( 
    select * 
    from {{ source(schema_name,table_name) }} 
    )

select * from src s

{% if is_incremental() %}
    where s.etl_created_dt > (select coalesce(max(t.etl_created_dt),'1790-01-01') from {{ this }} t)
{% endif %}

{% endmacro %}