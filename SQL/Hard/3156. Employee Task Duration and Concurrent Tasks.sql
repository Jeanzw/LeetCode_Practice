with max_concurrent_tasks as
(select
    a.employee_id, 
    a.task_id, 
    (count(distinct b.task_id) + 1) as task_cnt, 
    row_number() over (partition by a.employee_id order by (count(distinct b.task_id) + 1) desc) as rnk
from Tasks a
left join Tasks b on a.employee_id = b.employee_id and b.start_time > a.start_time and b.start_time < a.end_time
group by 1,2
)
, total_task_hours as
(select 
a.employee_id,
floor(sum(timestampdiff(minute, a.start_time,a.end_time) - (case when b.start_time is not null then timestampdiff(minute, b.start_time,a.end_time) else 0 end))/60) as total_task_hours
from Tasks a
left join Tasks b on a.employee_id = b.employee_id and b.start_time > a.start_time and b.start_time < a.end_time
group by 1)


select
    a.employee_id,
    a.total_task_hours,
    b.task_cnt as max_concurrent_tasks
from total_task_hours a
inner join max_concurrent_tasks b on a.employee_id = b.employee_id and b.rnk = 1
order by 1



-- Python
import pandas as pd

def find_total_duration(tasks: pd.DataFrame) -> pd.DataFrame:
    # 1. get next start time
    tasks = tasks.sort_values(by = ['employee_id', 'start_time'], ascending = [1, 1])
    tasks['next_start_time'] = tasks.groupby('employee_id')['start_time'].shift(-1)
    # 2. compute duration for each task
    tasks['duration'] = (tasks['end_time'] - tasks['start_time']).dt.total_seconds()
    # 3. check overlap
    tasks['is_overlap'] = np.where(tasks['next_start_time'] < tasks['end_time'], 1, 0)
    # 4. compute overlap time
    tasks['overlap_duration'] = np.where(tasks['is_overlap'] == 1, (tasks['end_time'] - tasks['next_start_time']).dt.total_seconds(), 0)
    # 5. aggregate and get final result
    tasks = tasks.groupby('employee_id').agg(
        total_duration_in_seconds = ('duration', 'sum'),
        total_overlap_duration_in_seconds = ('overlap_duration', 'sum'),
        concurrent_tasks_exclude_self = ('is_overlap', 'max')
    ).reset_index()
    # 6. compute total_task_hours and max_concurrent_tasks
    tasks['total_task_hours'] = (tasks['total_duration_in_seconds'] - tasks['total_overlap_duration_in_seconds']) // 3600
    tasks['max_concurrent_tasks'] = tasks['concurrent_tasks_exclude_self'] + 1
    return tasks[['employee_id', 'total_task_hours', 'max_concurrent_tasks']].sort_values(by = 'employee_id')