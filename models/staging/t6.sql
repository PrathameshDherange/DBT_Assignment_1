{# SCT Type 2 - comparing the rest of the data and making the decision of insert, update or ignore. #}

{{ config(materialized='ephemeral') }}

{{ scd2_hashkey_based_inc_load('info_schema_dbt_db','raw','employee_details','staging','t6') }}
