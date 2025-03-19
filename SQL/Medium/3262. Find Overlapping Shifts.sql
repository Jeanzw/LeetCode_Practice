select 
a.employee_id,
count(*) as overlapping_shifts
from EmployeeShifts a
inner join EmployeeShifts b 
on a.employee_id = b.employee_id 
and a.end_time > b.start_time and a.start_time < b.start_time 
group by 1

---------------------------

-- Python
import pandas as pd

def find_overlapping_shifts(employee_shifts: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employee_shifts,employee_shifts,on = 'employee_id')
    merge = merge[(merge['start_time_y'] > merge['start_time_x']) & (merge['start_time_y'] < merge['end_time_x'])]
    
    merge = merge.groupby(['employee_id'],as_index = False).size()
    return merge.rename(columns = {'size':'overlapping_shifts'}).sort_values('employee_id')