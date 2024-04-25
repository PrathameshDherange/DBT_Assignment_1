{# Append mode when key is not found - insert only if key is not present in target table. #}

{{ config(
    materialized='incremental', 
    incremental_strategy='append',
    unique_key='employee_id',
    tags=["emp_load"]
    ) 
}}

{{ append_new_macro(unique_key1='employee_id', schema_name='raw', table_name='employee_details') }}