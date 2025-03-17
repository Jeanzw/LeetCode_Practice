-- 这道题最关键的地方在于一个edge case：
-- | task_id | employee_id | start_time          | end_time            |
-- | ------- | ----------- | ------------------- | ------------------- |
-- | 1       | 1001        | 2023-05-01 00:00:00 | 2023-05-01 02:00:00 |
-- | 2       | 1001        | 2023-05-01 01:00:00 | 2023-05-01 03:00:00 |
-- | 3       | 1001        | 2023-05-01 01:12:00 | 2023-05-01 01:42:00 |
-- 上面的例子中我们可以看到task_id = 3，因为它是1和2的子集，所以我们在计算时间的时候其实这一行可以直接省略掉了
-- 为了解决掉这个edge case，我们用了edge_case找到它
-- 然后我们另外对Tasks进行处理，保留没有这个子集的内容
-- 我们在做concurrent_tasks的时候需要考虑这个子集，所以我们直接用Tasks这张表
-- 但是我们在计算时间的时候不需要考虑这个子集，所以我们用上面生成的summary这张表

with edge_case as
(select
distinct b.task_id
from Tasks a
join Tasks b on a.employee_id = b.employee_id and a.task_id != b.task_id and b.start_time >= a.start_time and b.end_time <= a.end_time)
, summary as
(select
a.*
from Tasks a
left join edge_case b on a.task_id = b.task_id
where b.task_id is null)
, max_concurrent_tasks as
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
from summary a
left join summary b on a.employee_id = b.employee_id and b.start_time > a.start_time and b.start_time < a.end_time
group by 1)


select
    a.employee_id,
    a.total_task_hours,
    b.task_cnt as max_concurrent_tasks
from total_task_hours a
inner join max_concurrent_tasks b on a.employee_id = b.employee_id and b.rnk = 1
order by 1

--------------------------------

-- Python
import pandas as pd
import numpy as np


def find_total_duration(tasks: pd.DataFrame) -> pd.DataFrame:
    # 找到edge case
    edge_case = pd.merge(tasks,tasks, on = 'employee_id')
    edge_case = edge_case[(edge_case['start_time_y'] >= edge_case['start_time_x']) & (edge_case['end_time_y'] <= edge_case['end_time_x']) & (edge_case['task_id_x'] != edge_case['task_id_y'])][['task_id_y']].drop_duplicates()
    # 形成一个新的表summary，里面装的是没有任何子集的数据，为的就是计算total_task_hours
    summary = tasks[~tasks['task_id'].isin(edge_case['task_id_y'])]
    # 计算按例来说的所有时间
    summary['total_hours_without_filter'] = (summary['end_time'] - summary['start_time']).dt.total_seconds()
    total_hours_without_filter = summary.groupby(['employee_id'],as_index = False).total_hours_without_filter.sum()

    # 计算overlap的时间
    overlap_df = pd.merge(summary,summary, on = 'employee_id')
    overlap_df['match_num'] = overlap_df.groupby(['employee_id','task_id_x']).task_id_x.transform('count')
    overlap_df = overlap_df[(overlap_df['task_id_x'] != overlap_df['task_id_y']) & (overlap_df['start_time_y'] >=  overlap_df['start_time_x']) & (overlap_df['start_time_y'] <=  overlap_df['end_time_x'])]
    overlap_df['overlap_hours'] = (overlap_df['end_time_x'] - overlap_df['start_time_y']).dt.total_seconds()
    overlap_hours = overlap_df.groupby(['employee_id'],as_index = False).overlap_hours.sum()

    # 计算total_task_hours
    total_task_hours = pd.merge(total_hours_without_filter,overlap_hours, on = 'employee_id', how = 'left').fillna(0)
    total_task_hours['total_task_hours'] = (total_task_hours['total_hours_without_filter'] - total_task_hours['overlap_hours'])//3600
    total_task_hours = total_task_hours[['employee_id','total_task_hours']]
    
    # 计算concurrent_tasks
    concurrent_tasks = pd.merge(tasks,tasks, on = 'employee_id')
    concurrent_tasks = concurrent_tasks[(concurrent_tasks['start_time_y'] >= concurrent_tasks['start_time_x']) & (concurrent_tasks['start_time_y'] < concurrent_tasks['end_time_x'])]
    concurrent_tasks = concurrent_tasks.groupby(['employee_id','task_id_x'],as_index = False).task_id_y.nunique()
    concurrent_tasks.sort_values(['employee_id','task_id_y'], ascending = [1,0], inplace = True)
    concurrent_tasks = concurrent_tasks.groupby(['employee_id']).head(1)
    concurrent_tasks = concurrent_tasks[['employee_id','task_id_y']].rename(columns = {'task_id_y':'max_concurrent_tasks'})
    # 最后做一个merge结束
    res = pd.merge(total_task_hours,concurrent_tasks,on = 'employee_id')
    return res.sort_values('employee_id')