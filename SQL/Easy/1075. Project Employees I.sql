select project_id,round(avg(experience_years),2) as average_years from Project p
left join Employee e
on p.employee_id = e.employee_id
group by 1


-- Python
import pandas as pd

def project_employees_i(project: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(project,employee,on = 'employee_id')
    merge = merge.groupby(['project_id'],as_index = False).experience_years.mean()
    merge['experience_years'] = merge['experience_years'].round(2)
    return merge.rename(columns = {'experience_years':'average_years'})