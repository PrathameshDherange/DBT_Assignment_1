{# Append mode when key is not found - insert only if key is not present in target table. #}

{{ config(materialized='incremental') }}

{{ append_new_inc_load('info_schema_dbt_db','raw','employee_details') }}
