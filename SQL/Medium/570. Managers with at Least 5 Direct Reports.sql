select Name from Employee where Id in
(select ManagerId from Employee
group by 1 having count(*) >= 5)


-- 也可以直接用join来做
select 
    a.Name
    from Employee a
    join Employee b on a.Id = b.ManagerId
    group by 1
    having count(distinct b.Id) >= 5



    -- 这道题改了，一个易错点在：可能有两个同名的manager
select
a.name
from Employee a
inner join Employee b on a.id = b.managerId
group by a.name, a.id
having count(distinct b.id) >= 5


-- Python
import pandas as pd

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    df = employee.groupby('managerId').size().reset_index(name='count')
    df = df[df['count'] >= 5]
    managers_info = pd.merge(df, employee, left_on='managerId', right_on='id', how='inner')
    return managers_info[['name']]