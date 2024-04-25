{#  If key is present then compare the rest of the data and if it is not the same then update else ignore. 
    If the key is not present then insert #}
{# merge_update_columns = ['employee_name', 'employee_salary', 'employee_department_id'] #}

{{ config(
    materialized='incremental', 
    incremental_strategy='merge',
    unique_key='employee_id',
    tags=["scd1","emp_load"]
    ) 
}}

{{ scd1_hashkey_based_macro(unique_key1='employee_id', 
                            schema_name='raw',
                            table_name='employee_details') }}
