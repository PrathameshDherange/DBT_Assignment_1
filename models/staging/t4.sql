{#  If key is present then compare the rest of the data and if it is not the same then update else ignore. 
    If the key is not present then insert #}

{{ config(materialized='ephemeral') }}

{{ scd1_hashkey_based_inc_load('info_schema_dbt_db','raw','employee_details','staging','t4') }}
