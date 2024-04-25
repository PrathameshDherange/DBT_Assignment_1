{# SCT Type 2 - comparing the rest of the data and making the decision of insert, update or ignore. #}

{{ config(materialized='ephemeral') }}

{# data should be same as t6 #}
{{ scd2_w_hashkey_test('info_schema_dbt_db','raw','employee_details','staging','scd2_load_ephemeral') }}
