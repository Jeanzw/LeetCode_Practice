with salary_rank as
(select 
d.Name as Department,
e.Name as Employee,
Salary,
dense_rank() over (partition by DepartmentId order by Salary desc) as rnk
from Employee e
join Department d
on e.DepartmentId = d.Id)

select Department, Employee, Salary from salary_rank
where rnk <= 3
 

-- Python
import pandas as pd

def top_three_salaries(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employee,department,left_on = 'departmentId',right_on = 'id')
    merge['rnk'] = merge.groupby(['departmentId']).salary.rank(method = 'dense', ascending = False)
    return merge.query("rnk <= 3")[['name_y','name_x','salary']].rename(columns = {'name_y':'Department','name_x':'Employee'})