{# SCD Type 1 - if key is present then update else insert into target table. #}

{{ config(materialized='incremental', unique_key = 'employee_id') }}

{{ scd1_pk_based_inc_load('info_schema_dbt_db','raw','employee_details') }}
