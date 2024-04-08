{% macro generate_database_name(custom_database_name, node) -%}

    {%- if custom_database_name is none -%}
        {%- if target.name == "dev" -%} dbt_db
        {%- elif target.name == "uat" -%} dbt_uat_db
        {%- elif target.name == "prod" -%} dbt_prod_db
        {%- else -%} invalid_database
        {%- endif -%}
    {%- else -%}
    {{ custom_database_name | trim }}
    {%- endif -%}

{%- endmacro %}