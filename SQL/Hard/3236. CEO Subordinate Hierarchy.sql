with recursive cte as
(select employee_id, employee_name, 0 as hierarchy_level, 0 as salary_difference
from Employees 
where manager_id is null
union all
select a.employee_id, a.employee_name, hierarchy_level + 1 as hierarchy_level, a.salary - (SELECT salary FROM Employees WHERE manager_id IS NULL) as salary_difference
from Employees a
inner join cte b on a.manager_id = b.employee_id
)

select 
employee_id as subordinate_id,
employee_name as subordinate_name,
hierarchy_level,
salary_difference
from cte where hierarchy_level > 0
order by 3,1
