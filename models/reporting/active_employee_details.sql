with emp_details as (
    select * from {{ ref("stg_employee_details") }}
),

dept_details as (
    select * from {{ ref("department_details") }}
),

dept_details2 as (
    select * from {{ source('staging','department_details') }}
)
select  e.employee_id, 
        e.employee_name, 
        e.employee_salary, 
        e.employee_department_id, 
        d.department_name as employee_department_name
from emp_details e
left join dept_details2 d on e.employee_department_id= d.department_id