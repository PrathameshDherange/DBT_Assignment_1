{% macro generate_hashkey(information_schema_name,schema_name,table_name) %}

{# get column list #}
{% set column_list %}
select upper(column_name) as column_name
from {{ source(information_schema_name,'columns') }} 
where lower(table_schema)='{{schema_name}}' and lower(table_name)='{{table_name}}' 
        and upper(column_name) not like 'ETL_%'
order by ordinal_position
{% endset %}

{# execute above query #}
{% set result_cols = run_query(column_list) %}

{# store column list #}
{% if execute %}
{% set result_col_lst = result_cols.columns[0].values() %}
{% else %}
{% set result_col_lst = [] %}
{% endif %}

{# generate hash_key #}
{% set hash_key %}
    {%- for col in result_col_lst -%}
        {%- if loop.first -%} md5_binary( {%- endif -%}
        coalesce(upper(s."{{col}}"),'#')
        {%- if not loop.last -%} || {%- endif -%}
        {%- if loop.last -%} ) {%- endif -%}
    {%- endfor -%}
{% endset %}

{% set hash_value %} {{hash_key}} {% endset %}
{{ return( hash_value ) }}

{% endmacro %}


