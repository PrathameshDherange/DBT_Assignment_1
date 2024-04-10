{% macro insert_at_start(text) %}

{#
{% set trunc_query %}
truncate table dbt_db.staging.audit_table
{% endset %}
{% set run_trunc = run_query(trunc_query) %}
#}

{% set insert_query %}
insert into dbt_db.staging.audit_table (Model_Process_name,started_at,completed_at)
                select '{{text}}', current_timestamp(), null
{% endset %}
{% set run_insert = run_query(insert_query) %}

{% endmacro %}

{#
    +pre_hook: "insert into dbt_db.staging.audit_table (Model_Process_name,started_at,completed_at)
                select '{{ this }}', current_timestamp(), null"
    +post_hook: "update dbt_db.staging.audit_table set completed_at = current_timestamp()
                 where model_Process_name='{{this}}'"
#}