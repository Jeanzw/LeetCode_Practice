with cte as
(select 
*,
row_number() over (partition by emp_id order by salary desc) as rnk
from Salary)

select emp_id,firstname, lastname,salary,department_id
from cte where rnk = 1
order by 1



-- Python
import pandas as pd

def find_latest_salaries(salary: pd.DataFrame) -> pd.DataFrame:
    salary = salary.sort_values(['emp_id','salary'], ascending = [1,0])
    return salary.groupby(['emp_id'],as_index = False).head(1)