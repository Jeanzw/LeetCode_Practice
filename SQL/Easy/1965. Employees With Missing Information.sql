select 
case when employee_id is not null then employee_id else semployee_id end as employee_id
from

(select e.employee_id,e.name,s.employee_id as semployee_id,s.salary
from Employees e
left join Salaries s on e.employee_id = s.employee_id
union
select e.employee_id,e.name,s.employee_id as semployee_id,s.salary
from Employees e
right join Salaries s on e.employee_id = s.employee_id)tmp
-- 按理来说上面这一串我们应该是直接用outer full join给解决的，但是mysql不支持，所以为了达到这个目的，我们需要用left join和right join一同解决这个问题
where name is null or salary is null
order by 1

-- 但是如果我们使用ms sql那么就可以用full outer join了
SELECT CASE WHEN name IS NULL THEN s.employee_id
            WHEN salary IS NULL THEN e.employee_id
            END as employee_id
FROM Employees e
FULL OUTER JOIN Salaries s
ON e.employee_id = s.employee_id
WHERE name IS NULL or salary IS NULL          -- get the ones without proper information
ORDER BY employee_id


-- 或者这样做
with frame as
(select employee_id from Employees
union
select employee_id from Salaries)

select
distinct a.employee_id
from frame a
left join Employees b on a.employee_id = b.employee_id
left join Salaries c on a.employee_id = c.employee_id
where b.employee_id is null or c.employee_id is null
order by 1


-- Python
import pandas as pd

def find_employees(employees: pd.DataFrame, salaries: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employees,salaries,on='employee_id', how='outer').query("name.isna() or salary.isna()")
    return merge[['employee_id']].sort_values('employee_id')