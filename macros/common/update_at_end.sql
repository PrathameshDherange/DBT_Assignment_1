{% macro update_at_end(text) %}

{% set insert_query %}
update dbt_db.staging.audit_table set completed_at = current_timestamp()
                 where model_Process_name='{{text}}'
{% endset %}
{% set run_insert = run_query(insert_query) %}

{% endmacro %}