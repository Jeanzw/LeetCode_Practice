select
a.employee_id as employee_id
from Employees a
left join Logs b on a.employee_id = b.employee_id
group by 1,a.needed_hours
-- 这里groupby需要有needed_hours存在，不然我们在下面having的时候是找不到needed_hours的
having ifnull(sum(ceiling(timestampdiff(second,in_time,out_time)/60)),0) < needed_hours * 60


-- Python
import pandas as pd

def employees_with_deductions(employees: pd.DataFrame, logs: pd.DataFrame) -> pd.DataFrame:
    logs['time'] = (logs['out_time'] - logs['in_time']).dt.ceil('1min').dt.seconds // 60
    logs = logs.groupby(['employee_id'], as_index = False).time.sum()
    logs['time'] = logs['time'] // 60
    summary = pd.merge(employees,logs, on = 'employee_id', how = 'left').fillna(0)
    return summary.query("needed_hours > time")[['employee_id']]