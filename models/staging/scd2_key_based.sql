{# SCD Type 2 - if key is present - close the existing record and then insert the new record for the same key. 
    If the key is not present then insert. no hashkey comparision #}

{{ config(
    materialized='incremental', 
    incremental_strategy='merge',
    unique_key='employee_id',
    tags=["scd2","emp_load"]
    ) 
}}

{{ scd2_key_based_macro(schema_name='raw',
                            table_name='employee_details') }}
