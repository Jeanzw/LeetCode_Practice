with cte as
(select 
a.employee_id, a.start_time,
count(distinct b.start_time) + 1 as max_overlapping_shifts,
ifnull(sum(timestampdiff(minute,b.start_time,a.end_time)),0) as total_overlap_duration
from EmployeeShifts a
left join EmployeeShifts b on a.employee_id = b.employee_id and date(a.start_time) = date(b.start_time) and a.end_time > b.start_time and a.start_time < b.start_time
group by 1,2
order by 1)

select 
    employee_id,
    max(max_overlapping_shifts) as max_overlapping_shifts,
    sum(total_overlap_duration) as total_overlap_duration
from cte
group by 1


-- Python
import pandas as pd
import numpy as np
def calculate_shift_overlaps(employee_shifts: pd.DataFrame) -> pd.DataFrame:
    employee_shifts['start_time'] = pd.to_datetime(employee_shifts['start_time'])
    employee_shifts['end_time'] = pd.to_datetime(employee_shifts['end_time'])
    merge = pd.merge(employee_shifts,employee_shifts,on = 'employee_id',how = 'left')

# step1: get employee_id who has no overlapping shift
    without_overlap = merge.query("start_time_x.dt.year == start_time_y.dt.year and start_time_x.dt.month == start_time_y.dt.month and start_time_x.dt.day == start_time_y.dt.day")
    without_overlap = without_overlap.groupby(['employee_id','start_time_x'],as_index = False).start_time_y.nunique()
    without_overlap = without_overlap.groupby(['employee_id'],as_index = False).start_time_y.max()
    without_overlap = without_overlap.query("start_time_y == 1").rename(columns = {'start_time_y':'max_overlapping_shifts'})
    without_overlap['total_overlap_duration'] = 0
# step2: process employee_id who has overlapping shift
    with_overlap = merge.query("end_time_x > start_time_y and start_time_x < start_time_y and start_time_x.dt.year == start_time_y.dt.year and start_time_x.dt.month == start_time_y.dt.month and start_time_x.dt.day == start_time_y.dt.day")
    with_overlap['total_overlap_duration'] = (with_overlap['end_time_x'] - with_overlap['start_time_y']).dt.seconds/60
    with_overlap = with_overlap.groupby(['employee_id','start_time_x'],as_index = False).agg(
        overlapping_shifts = ('start_time_y','nunique'),
        total_overlap_duration = ('total_overlap_duration','sum')
    )
    with_overlap = with_overlap.groupby(['employee_id'],as_index = False).agg(
        max_overlapping_shifts = ('overlapping_shifts','max'),
        total_overlap_duration = ('total_overlap_duration','sum')
    )
    with_overlap['max_overlapping_shifts'] = with_overlap['max_overlapping_shifts'] + 1
# step3: return the result
    return pd.concat([with_overlap,without_overlap]).sort_values('employee_id')