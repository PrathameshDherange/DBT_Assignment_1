{% macro get_pk_macro(alias,schema_name,table_name) %}

{% set desc_query %} show primary keys in {{schema_name}}.{{table_name}} {% endset %}
{% set pk_query %} select $5 as column_name from table(result_scan(last_query_id())) order by $6 {% endset %}

{% set run_desc = run_query(desc_query) %}
{% set run_pk = run_query(pk_query) %}
{% if execute %}
{% set pk_list = run_pk.columns[0].values() %}
{% else %}
{% set pk_list = [] %}
{% endif %}

{% set p_key %}
    {%- for col in pk_list -%}
        {%- if loop.first -%} concat( {%- endif -%}
        {{alias}}.{{col}}
        {%- if not loop.last -%} , {%- endif -%}
        {%- if loop.last -%} ) {%- endif -%}
    {%- endfor -%}
{% endset %}

{% set pklist %} {{p_key}} {% endset %}
{{ return( pklist ) }}

{% endmacro %}

{# {% set var1 %} ({{ get_pk_macro('s','staging','t1') }}) {% endset %} #}