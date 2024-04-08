{% snapshot employee_details_snapshot %}

{{
    config(
        target_schema = 'snapshot',
        unique_key = 'employee_id',

        strategy = 'timestamp',
        updated_at = 'etl_created_dt'
    )
}}

select * from {{source('raw','employee_details')}}

{% endsnapshot %}