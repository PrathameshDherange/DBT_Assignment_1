{# Append mode - whatever is coming from source, insert to target table #}

{{ config(
    materialized='incremental', 
    incremental_strategy='append',
    tags=["emp_load"]
    ) 
}}

{{ append_all_macro(schema_name='raw', table_name='employee_details') }}