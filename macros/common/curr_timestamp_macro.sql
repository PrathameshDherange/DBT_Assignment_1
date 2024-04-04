{% macro curr_timestamp_macro() %}

{% set cur_timestmp %} select current_timestamp()::timestamp_ntz {% endset %}
{% set cur_timestmp_res = run_query(cur_timestmp) %}
{% if execute %}
{% set cur_timestmp_val = cur_timestmp_res.columns[0].values()[0] %}
{% else %} 
{% set cur_timestmp_val = 9999-12-31 %}
{% endif %}
{% set curr_timestamp_var %} ('{{cur_timestmp_val}}'::timestamp_ntz ) {% endset %}
{{ return(curr_timestamp_var ) }}

{% endmacro %}