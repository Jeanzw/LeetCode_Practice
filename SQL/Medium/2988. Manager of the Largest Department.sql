with cnt as
(select
dep_id,
dense_rank() over (order by count(distinct emp_id) desc) as rnk
from Employees
group by 1)

select
emp_name as manager_name,
dep_id
from Employees
where position = 'Manager'
and dep_id in (select dep_id from cnt where rnk = 1)
order by 2


-- 或者这样做
with cte1 as
(select
*,
count(*) over (partition by dep_id) as cnt
from Employees)
, cte2 as
(select *, dense_rank() over (order by cnt desc) as rnk from cte1)

select emp_name as manager_name, dep_id from cte2 where rnk = 1 and position = 'Manager' order by 2


-- Python
import pandas as pd

def find_manager(employees: pd.DataFrame) -> pd.DataFrame:
    employees['cnt'] = employees.groupby(['dep_id']).emp_id.transform('count')
    employees['rnk'] = employees.cnt.rank(method = 'dense', ascending = False)
    return employees.query("rnk == 1 and position == 'Manager'")[['emp_name','dep_id']].rename(columns = {'emp_name':'manager_name'}).sort_values('dep_id')