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

---------------------------------------

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

---------------------------------------

-- Python
import pandas as pd
import numpy as np

def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    activity['timestamp'] = np.where(activity['activity_type'] == 'start',-activity['timestamp'],activity['timestamp'])
    activity = activity.groupby(['machine_id','process_id'],as_index = False).timestamp.sum()
    activity = activity.groupby(['machine_id'],as_index = False).timestamp.mean().round(3)
    return activity.rename(columns = {'timestamp':'processing_time'})


-- 也可以这么做
import pandas as pd

def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    activity.sort_values(['machine_id','process_id','activity_type'],ascending = [1,1,0],inplace = True)
    activity['end_timestamp'] = activity.groupby(['machine_id','process_id']).timestamp.shift(-1)
    activity = activity[activity['end_timestamp'].notna()]
    activity['processing_time'] = activity['end_timestamp'] - activity['timestamp']
    activity = activity.groupby(['machine_id'],as_index = False).processing_time.mean().round(3)
    return activity