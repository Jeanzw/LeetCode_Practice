select 
    machine_id,
    -- process_id,
    round(sum(case when activity_type = 'end' then timestamp else -timestamp end)
    /
    count(distinct process_id),3)
    as processing_time
    from Activity group by 1

    -- 说实话，这道题一旦想通计算时间是用这个共识：((1.520 - 0.712) + (4.120 - 3.140))
    -- 那么很多问题就可以想通，无论process中间是否有间隔，只要我们把start定义为负数，end定义为正数，那么无论怎么变化，我们的原理都是求和



    -- 
with summary as
(select 
    machine_id,
    process_id,
    sum(case when activity_type = 'end' then timestamp else -timestamp end) as duration
from Activity
group by 1,2)

select 
    machine_id, 
    round(avg(duration),3) as processing_time 
    from summary group by 1 order by 1


-- Python
import pandas as pd

def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    activity['timestamp'] = np.where(activity['activity_type'] == 'start',-activity['timestamp'], activity['timestamp'])
    activity = activity.groupby(['machine_id'], as_index = False).agg(
    sum_time = ('timestamp','sum'),
    sum_process = ('process_id','nunique')
)
    activity['processing_time'] = round(activity['sum_time']/activity['sum_process'],3)
    return activity[['machine_id','processing_time']]    