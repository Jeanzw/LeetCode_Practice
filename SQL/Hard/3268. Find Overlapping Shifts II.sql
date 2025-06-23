with cte as
(select 
a.employee_id, a.start_time,
count(distinct b.start_time) + 1 as max_overlapping_shifts,
ifnull(sum(timestampdiff(minute,b.start_time,a.end_time)),0) as total_overlap_duration
from EmployeeShifts a
left join EmployeeShifts b on a.employee_id = b.employee_id and a.end_time > b.start_time and a.start_time < b.start_time
group by 1,2
order by 1)

select 
    employee_id,
    max(max_overlapping_shifts) as max_overlapping_shifts,
    sum(total_overlap_duration) as total_overlap_duration
from cte
group by 1

-------------------------------------

-- Python
import pandas as pd

def calculate_shift_overlaps(employee_shifts: pd.DataFrame) -> pd.DataFrame:
    # 先把对应的日期给求出来，因为题目中要求是发生在同一天的,如果没有这一个步骤，是通不过test的
    employee_shifts['start_time_dt'] = employee_shifts.start_time.dt.strftime('%Y-%m-%d')
    employee_shifts['start_time_dt'] = pd.to_datetime(employee_shifts['start_time_dt'])

    employee_shifts['end_time_dt'] = employee_shifts.end_time.dt.strftime('%Y-%m-%d')
    employee_shifts['end_time_dt'] = pd.to_datetime(employee_shifts['end_time_dt'])   
    
    # 然后去求存在重复的内容
    merge = pd.merge(employee_shifts,employee_shifts,on = 'employee_id')
    merge = merge[((merge['start_time_dt_x'] == merge['start_time_dt_y']) | (merge['start_time_dt_x'] == merge['end_time_dt_y'])) & (merge['start_time_y'] > merge['start_time_x']) & (merge['start_time_y'] <= merge['end_time_x'])]
    merge = merge[['employee_id','start_time_x','end_time_x','start_time_y','end_time_y']]
    merge['diff'] = (merge['end_time_x'] - merge['start_time_y']).dt.total_seconds()/60
    merge = merge.groupby(['employee_id','start_time_x'],as_index = False).agg(
        total_overlap_duration = ('diff','sum'),
        overlapping_shifts = ('start_time_y','nunique')
    )
    merge = merge.groupby(['employee_id'],as_index = False).agg(
        max_overlapping_shifts = ('overlapping_shifts','max'),
        total_overlap_duration = ('total_overlap_duration','sum')
    )

    # 最后我们要把不存在重复值的内容找出来，并且给它赋值0
    user_list = employee_shifts[['employee_id']].drop_duplicates()

    res = pd.merge(user_list,merge, on = 'employee_id', how = 'left').fillna(0)
    res['max_overlapping_shifts'] = res['max_overlapping_shifts'] + 1
    return res.sort_values('employee_id')