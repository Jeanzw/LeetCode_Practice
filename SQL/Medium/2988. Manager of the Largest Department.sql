with cnt as
(select
dep_id,
dense_rank() over (order by count(distinct emp_id) desc) as rnk
from Employees
group by 1)

select
emp_name as manager_name,
dep_id
from Employees
where position = 'Manager'
and dep_id in (select dep_id from cnt where rnk = 1)
order by 2