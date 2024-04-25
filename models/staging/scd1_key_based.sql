{# SCD Type 1 - if key is present then update else insert into target table. #}
{# merge_update_columns = ['employee_name', 'employee_salary', 'employee_department_id'] #}

{{ config(
    materialized='incremental', 
    incremental_strategy='merge',
    unique_key='employee_id',
    tags=["scd1","emp_load"]
    ) 
}}

{{ scd1_key_based_macro(unique_key1='employee_id',
                        schema_name='raw', table_name='employee_details') }}
