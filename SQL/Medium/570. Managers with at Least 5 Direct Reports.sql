select Name from Employee where Id in
(select ManagerId from Employee
group by 1 having count(*) >= 5)

-- 这道题改了，一个易错点在：可能有两个同名的manager,所以我们groupby需要有两个
select
a.name
from Employee a
inner join Employee b on a.id = b.managerId
group by a.name, a.id
having count(distinct b.id) >= 5

-----------------------

-- Python
-- 我觉得这些test真的很离谱……有一个test是name一栏是null，但是是满足条件的，我们返回的name需要把null给返回
-- 如果不考虑这个离谱的test，那么我们下面的code是可以用的
import pandas as pd

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employee,employee,left_on = 'id', right_on = 'managerId')
    merge = merge.groupby(['id_x','name_x'],as_index = False).id_y.nunique()
    merge = merge.rename(columns = {'name_x':'name'})
    result = merge.query("id_y >= 5")
    return result[['name']]

-----------------------

-- 如果我们考虑这种离谱的test，那么下面的code可以满足
import pandas as pd

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    employee_5_direct = employee.groupby(['managerId'],as_index = False).id.nunique()
    employee_5_direct = employee_5_direct.query('id>=5')
    merge = pd.merge(employee_5_direct,employee,left_on = 'managerId',right_on = 'id')
    return merge[['name']]

-----------------------

-- 另外的做法
import pandas as pd

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    manager = employee.groupby(['managerId'],as_index = False).id.nunique()
    manager = manager[manager['id'] >= 5]

    employee = employee[employee['id'].isin(manager['managerId'])]
    return employee[['name']]