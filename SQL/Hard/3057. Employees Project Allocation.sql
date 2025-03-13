with average_team as
(select 
team,
workload,
a.employee_id,
project_id,
name,
avg(workload) over (partition by a.team) as avg_team
from Employees a
left join Project b on a.employee_id = b.employee_id
)

select 
employee_id,
project_id,
name as employee_name,
workload as project_workload
from average_team
where workload > avg_team
order by 1,2

---------------------------

-- Python
import pandas as pd

def employees_with_above_avg_workload(project: pd.DataFrame, employees: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(project,employees,on = 'employee_id', how = 'left')
    merge['team_avg'] = merge.groupby(['team']).workload.transform('mean')
    merge = merge[merge['workload'] > merge['avg_workload']]
    return merge[['employee_id','project_id','name','workload']].rename(columns = {'name':'employee_name','workload':'project_workload'}).sort_values(['employee_id','project_id'])