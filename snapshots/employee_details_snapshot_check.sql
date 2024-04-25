{% snapshot employee_details_snapshot_check %}

{{
    config(
        target_schema = 'snapshot',
        unique_key = 'employee_id',

        strategy = 'check',
        check_cols=['employee_name', 'employee_salary', 'employee_department_id'],
        invalidate_hard_deletes=True
    )
}}

select * from {{source('raw','employee_details')}}

{% endsnapshot %}
          