-- 我的方法
-- 先用rank来找出最大的salary，然后根据salary了解tax，最后用这个tax去left join原本的工资表
with rank as
(select *,
rank() over (partition by company_id order by salary desc) as rnk
from Salaries)
, tax as
(select company_id,
case when salary < 1000 then 0
when salary > 10000 then 0.49
else 0.24 end as tax
from rank
where rnk = 1)

select 
    s.company_id, 
    employee_id,
    employee_name,
    round(s.salary - s.salary * tax,0) as salary 
from Salaries s left join tax t on s.company_id = t.company_id


-- 用mysql写的
select s.company_id, s.employee_id, s.employee_name,
round(
		case when x.max_sal between 1000 and 10000 then salary * 0.76
		when x.max_sal > 10000 then salary * 0.51 else salary end, 0) as salary

from salaries s inner join
(select company_id, max(salary) max_sal from salaries group by company_id) x

on s.company_id = x.company_id;


-- 后来自己写的：
with company_max_salary as
(select company_id, max(salary) as max_salary from Salaries group by 1)
-- 先求出每家公司最大的salary

select 
    s.company_id,
    employee_id,
    employee_name,
    round((salary 
    - 
    case when max_salary < 1000 then 0
    when max_salary between 1000 and 10000 then salary * 0.24
    else salary * 0.49 end),0) as salary
    from Salaries s 
    left join company_max_salary c on s.company_id = c.company_id


-- 其实case when里面是可以进行计数操作的
with tax as
(select 
company_id,
case when max(salary) < 1000 then 0 
when max(salary) >= 1000 and max(salary) <= 10000 then 0.24
else 0.49
end as tax
from Salaries
group by 1)

select 
s.company_id,
s.employee_id,
s.employee_name,
round(s.salary * (1 - tax),0) as salary
from Salaries s
left join tax t on s.company_id = t.company_id

-- 再一次写的时候直接window function来写
with cte as
(select 
*, 
case when max(salary) over (partition by company_id) < 1000 then 1
     when max(salary) over (partition by company_id) <= 10000 then (1 - 0.24)
     else (1 - 0.49) end as tax
from Salaries)

select 
    company_id,
    employee_id,
    employee_name,
    round(salary * tax,0) as salary
from cte


-- Python
import pandas as pd
import numpy as np

def calculate_salaries(salaries: pd.DataFrame) -> pd.DataFrame:
    salaries['max_salary'] = salaries.groupby(['company_id']).salary.transform('max')
    salaries['tax'] = np.where(salaries['max_salary'] < 1000, 1,
                      np.where(salaries['max_salary'] <=10000, 1 - 0.24, 1-0.49))
    salaries['salary'] = round(salaries['tax'] * salaries['salary'] + 1e-9,0)

    return salaries[['company_id','employee_id','employee_name','salary']]