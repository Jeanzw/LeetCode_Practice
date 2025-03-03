select
a.employee_id as employee_id
from Employees a
left join Logs b on a.employee_id = b.employee_id
group by 1,a.needed_hours
-- 这里groupby需要有needed_hours存在，不然我们在下面having的时候是找不到needed_hours的
having ifnull(sum(ceiling(timestampdiff(second,in_time,out_time)/60)),0) < needed_hours * 60

---------------------------------------

-- 更方便阅读的方法：
with cte as
(select
a.needed_hours,
a.employee_id,
ifnull(sum(ceiling(timestampdiff(second, in_time, out_time)/60)),0) as diff
from Employees a
left join Logs b on a.employee_id = b.employee_id
group by 1,2
having diff < needed_hours * 60)

select employee_id from cte

---------------------------------------

-- Python
import pandas as pd

def employees_with_deductions(employees: pd.DataFrame, logs: pd.DataFrame) -> pd.DataFrame:
    logs['working'] = (logs['out_time'] - logs['in_time']).dt.ceil('min').dt.total_seconds() // 60
    logs = logs.groupby(['employee_id'],as_index = False).working.sum()

    merge = pd.merge(employees,logs, on = 'employee_id', how = 'left').fillna(0)
    merge['needed_min'] = merge['needed_hours'] * 60
    return merge[merge['working'] < merge['needed_min']][['employee_id']]