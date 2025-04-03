select project_id,employee_id from
(select project_id,p.employee_id,experience_years,dense_rank() over (partition by project_id order by experience_years desc) as rnk from Project p
left join Employee e
on p.employee_id = e.employee_id)tmp
where rnk = 1

---------------------------------

-- 或者还是可以用求最小值最大值的经典做法，虽然很慢
select p.* from Project p
left join Employee e on p.employee_id = e.employee_id
where (project_id,experience_years) in 
(select 
project_id,
max(experience_years) as max_experience
from Project p
left join Employee e on p.employee_id = e.employee_id
group by 1)

---------------------------------

-- Python
import pandas as pd

def project_employees(project: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(project,employee,on = 'employee_id')
    merge['rnk'] = merge.groupby(['project_id']).experience_years.rank(method = 'dense', ascending = False)
    merge = merge[merge['rnk'] == 1]
    return merge[['project_id','employee_id']]

---------------------------------

-- 也可以这么做
import pandas as pd

def project_employees(project: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(project,employee,on = 'employee_id')
    merge['max_years'] = merge.groupby(['project_id']).experience_years.transform('max')
    merge = merge[merge['max_years'] == merge['experience_years']]
    return merge[['project_id','employee_id']]