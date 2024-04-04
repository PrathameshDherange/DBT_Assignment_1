{# SCD Type 2 - if key is present - close the existing record and then insert the new record for the same key. 
    If the key is not present then insert. no hashkey comparision #}

{{ config(materialized='ephemeral') }}

{{ scd2_pk_based_inc_load('info_schema_dbt_db','raw','employee_details','staging','t5') }}
