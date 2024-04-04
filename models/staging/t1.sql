{# Append mode - whatever is coming from source, insert to target table #}

{{ config(materialized='incremental') }}

{{ append_all_inc_load('info_schema_dbt_db','raw','employee_details') }}