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
    # Constants
    budget = 70000

    # 把Senior和junior给分别抽出来，并且排序号
    senior = candidates[candidates['experience'] == 'Senior'].sort_values('salary')
    junior = candidates[candidates['experience'] == 'Junior'].sort_values('salary')

    # 分别计算各自的累计求和
    senior['cumsum'] = senior.salary.cumsum()
    junior['cumsum'] = junior.salary.cumsum()

    # 先算Senior可以找的数量
    senior = senior[senior['cumsum'] <= budget]
    budget_junior = budget - senior.salary.sum()

    # 用剩下的钱去看可以招多少junior
    junior = junior[junior['cumsum'] <= budget_junior]

    # 最后整理数据
    res = pd.concat([senior[['employee_id']],junior[['employee_id']]])
    return res