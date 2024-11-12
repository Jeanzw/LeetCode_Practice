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
-- 我们应该注意到这里是没有group by，没有group by那么当一个senior都不符合的时候，返回的是0，不然啥也不返回……

union all

select
'Junior' as experience,
count(distinct employee_id) as accepted_candidates
from junior
where sum_salary <= (70000 - (select ifnull(max(sum_salary),0) from senior where sum_salary <= 70000))
-- 这里我们在最后的where里面一定要让ifnull(max(sum_salary),0)，不然如果senior没有一个符合的时候就会导致Junior这里也是0


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

    # 把Senior和junior给分别抽出来，并且排序号
    seniors = candidates[candidates["experience"] == "Senior"].sort_values(by="salary")
    juniors = candidates[candidates["experience"] == "Junior"].sort_values(by="salary")

    # 分别计算各自的累计求和
    seniors["cumulative_salary"] = seniors["salary"].cumsum()
    juniors["cumulative_salary"] = juniors["salary"].cumsum()

    # 先算Senior可以找的数量
    seniors_hired = seniors[seniors["cumulative_salary"] <= BUDGET]
    remaining_budget = BUDGET - seniors_hired["salary"].sum()
    -- 这里我们用sum()因为如果我们用max()，如果不存在，那么返回的是null不是0

    # 用剩下的钱去看可以招多少junior
    juniors_hired = juniors[juniors["cumulative_salary"] <= remaining_budget]

    # 最后整理数据
    result = pd.DataFrame(
        {
            "experience": ["Senior", "Junior"],
            "accepted_candidates": [len(seniors_hired), len(juniors_hired)],
        }
    )

    return result
