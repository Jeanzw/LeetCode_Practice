with senior as
(select
    employee_id,
    salary,
    sum(salary) over (order by salary, employee_id) as sum_salary
    from Candidates
    where experience = 'Senior')
, junior as
(select
    employee_id,
    salary,
    sum(salary) over (order by salary, employee_id) as sum_salary
    from Candidates
    where experience = 'Junior'
)

select
'Senior' as experience,
ifnull(count(distinct employee_id),0) as accepted_candidates
from senior
where sum_salary <= 70000

union all

select
'Junior' as experience,
count(distinct employee_id) as accepted_candidates
from junior
where sum_salary <= (70000 - (select ifnull(max(sum_salary),0) from senior where sum_salary <= 70000))

