#mysql
select Department.Name as Department, Employee.Name as Employee, Salary
from Employee
join Department on Employee.DepartmentId = Department.Id
where (Employee.DepartmentId, Salary) in
(select DepartmentId, max(Salary) from Employee group by DepartmentId)

#ms sql  
/* Write your T-SQL query statement below */
select Department,Employee,Salary
from (select d.Name as Department, e.Name as Employee,Salary,dense_rank() over (partition by DepartmentId order by Salary desc) ranking from Employee e join Department d on e.DepartmentId = d.Id)tmp
where ranking = 1

/*注意这里的join是内链接而不是left join，因为我们不能保证Employee这一张表中所有的人都只是在这两个部门里面