with cte as
(select 
*,
row_number() over (partition by emp_id order by salary desc) as rnk
from Salary)

select emp_id,firstname, lastname,salary,department_id
from cte where rnk = 1
order by 1

------------------

-- Python
import pandas as pd

def find_latest_salaries(salary: pd.DataFrame) -> pd.DataFrame:
    salary = salary.sort_values(['emp_id','salary'], ascending = [1,0])
    return salary.groupby(['emp_id'],as_index = False).head(1)

-------------------

-- 也可以
import pandas as pd

def find_latest_salaries(salary: pd.DataFrame) -> pd.DataFrame:
    salary['rnk'] = salary.groupby(['emp_id']).salary.rank(ascending = False)
    res = salary[salary['rnk'] == 1]

    return res[['emp_id','firstname','lastname','salary','department_id']].sort_values('emp_id')