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