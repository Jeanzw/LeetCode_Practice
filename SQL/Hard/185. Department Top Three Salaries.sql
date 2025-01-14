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
    merge = pd.merge(department,employee,left_on = 'id', right_on = 'departmentId')
    merge['rnk'] = merge.groupby(['id_x']).salary.rank(method = 'dense', ascending = False)
    return merge[merge['rnk'] <= 3][['name_x','name_y','salary']].rename(columns = {'name_x':'Department','name_y':'Employee'})