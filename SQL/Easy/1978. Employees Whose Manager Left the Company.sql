select
distinct e1.employee_id
from Employees e1
left join Employees e2 on e1.manager_id = e2.employee_id
where e2.employee_id is null and e1.salary <30000 and e1.manager_id is not null
order by 1