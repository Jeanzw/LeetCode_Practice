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


-- Python
import pandas as pd

def number_of_joiners(candidates: pd.DataFrame) -> pd.DataFrame:
    senior = candidates.query("experience == 'Senior'").sort_values("salary")
    junior = candidates.query("experience == 'Junior'").sort_values("salary")

    senior['cum_sum'] = senior.salary.cumsum()
    junior['cum_sum'] = junior.salary.cumsum()

    senior = senior.query("cum_sum <= 70000")
    left_money = 70000 - senior.salary.sum()
    junior = junior[junior['cum_sum'] <= left_money]

    res = pd.concat([senior[['employee_id']],junior[['employee_id']]])

    return res