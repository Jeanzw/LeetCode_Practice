with salary_rank as
(select 
d.Name as Department,
e.Name as Employee,
Salary,
dense_rank() over (partition by DepartmentId order by Salary desc) as rnk
from Employee e
join Department d
on e.DepartmentId = d.Id)

select Department, Employee, Salary from salary_rank
where rnk <= 3