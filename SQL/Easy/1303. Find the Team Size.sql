with team_size as
(select team_id, count(*) as num from Employee
group by 1)

select employee_id, num as team_size from Employee e
left join team_size ts on e.team_id = ts.team_id

------------------------------------

-- 用join来做就是：
select
e1.employee_id,
count(distinct e2.employee_id) as team_size
from Employee e1
left join Employee e2 on e1.team_id = e2.team_id
group by 1

------------------------------------

-- 直接用window function
select 
    employee_id,
    count(employee_id) over (partition by team_id) as team_size
    from Employee

------------------------------------

-- Python
import pandas as pd

def team_size(employee: pd.DataFrame) -> pd.DataFrame:
    team_size = employee.groupby(['team_id'], as_index = False).employee_id.count().rename(columns = {'employee_id':'team_size'})
    
    merge = pd.merge(employee,team_size, how = 'left',on = 'team_id')
    return merge[['employee_id','team_size']]

------------------------------------

-- 不需要像上面这么复杂
import pandas as pd

def team_size(employee: pd.DataFrame) -> pd.DataFrame:
    employee['team_size'] = employee.groupby(['team_id']).employee_id.transform('nunique')
    return employee[['employee_id','team_size']]