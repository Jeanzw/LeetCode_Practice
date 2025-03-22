# Write your MySQL query statement below
with cte as
(select
*,
dense_rank() over (partition by dept order by salary desc) as rnk
from employees)

select emp_id, dept from cte
where rnk = 2
order by 1

---------------------------

-- Python
import pandas as pd

def find_second_highest_salary(employees: pd.DataFrame) -> pd.DataFrame:
    employees['rnk'] = employees.groupby(['dept']).salary.rank(method = 'dense', ascending = False)
    employees = employees[employees['rnk'] == 2]
    return employees[['emp_id','dept']].sort_values('emp_id')