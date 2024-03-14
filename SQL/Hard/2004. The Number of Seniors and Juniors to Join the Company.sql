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



-- 其实上面的给senior和junior统计工资，我们完全可以用一个cte解决
with summary as
(select
    employee_id,experience,
    salary, 
    sum(salary) over (partition by experience order by salary, employee_id) as sum_salary
    from Candidates)

select
'Senior' as experience,
ifnull(count(distinct employee_id),0) as accepted_candidates
from summary
where sum_salary <= 70000 and experience = 'Senior'

union all

select
'Junior' as experience,
count(distinct employee_id) as accepted_candidates
from summary
where sum_salary <= (70000 - (select ifnull(max(sum_salary),0) from summary where sum_salary <= 70000 and experience = 'Senior')) and experience = 'Junior'



-- Python
import pandas as pd

def count_seniors_and_juniors(candidates: pd.DataFrame) -> pd.DataFrame:
    # Constants
    BUDGET = 70000

    # Separate seniors and juniors and sort by salary
    seniors = candidates[candidates["experience"] == "Senior"].sort_values(by="salary")
    juniors = candidates[candidates["experience"] == "Junior"].sort_values(by="salary")

    # Calculate cumulative salaries
    seniors["cumulative_salary"] = seniors["salary"].cumsum()
    juniors["cumulative_salary"] = juniors["salary"].cumsum()

    # Determine how many seniors can be hired
    seniors_hired = seniors[seniors["cumulative_salary"] <= BUDGET]
    remaining_budget = BUDGET - seniors_hired["salary"].sum()

    # Determine how many juniors can be hired with the remaining budget
    juniors_hired = juniors[juniors["cumulative_salary"] <= remaining_budget]

    # Prepare the result
    result = pd.DataFrame(
        {
            "experience": ["Senior", "Junior"],
            "accepted_candidates": [len(seniors_hired), len(juniors_hired)],
        }
    )

    return result
