with sum_rank as
(select
employee_id,
experience,
salary,
sum(salary) over (partition by experience order by salary, employee_id) as rnk
from Candidates)
, senior as
(select employee_id, salary,rnk from sum_rank where experience = 'Senior' and rnk <= 70000)
, junior as
(select employee_id, salary from sum_rank where experience = 'Junior' and rnk <= 70000 - (select ifnull(max(rnk),0) from senior))

select employee_id from senior
union all
select employee_id from junior