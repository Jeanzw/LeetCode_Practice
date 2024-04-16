with average_team as
(select 
team,
workload,
a.employee_id,
project_id,
name,
avg(workload) over (partition by a.team) as avg_team
from Employees a
left join Project b on a.employee_id = b.employee_id
)

select 
employee_id,
project_id,
name as employee_name,
workload as project_workload
from average_team
where workload > avg_team
order by 1,2