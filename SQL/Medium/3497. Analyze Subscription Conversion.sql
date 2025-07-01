with cte as
(select
user_id,
activity_type,
round(sum(activity_duration) /count(distinct activity_date),2) as avg_duration,
count(activity_type) over (partition by user_id) as cnt
from UserActivity
where activity_type in ('free_trial','paid')
group by 1,2)

select 
user_id,
sum((case when activity_type = 'free_trial' then avg_duration else 0 end)) as trial_avg_duration,
sum((case when activity_type = 'paid' then avg_duration else 0 end)) as paid_avg_duration
from cte
where cnt = 2
group by 1
order by 1

---------------------------
-- Python的做法
import pandas as pd
import numpy as np

def analyze_subscription_conversion(user_activity: pd.DataFrame) -> pd.DataFrame:
    user_activity = user_activity[user_activity['activity_type'].isin(['free_trial','paid'])]
    user_activity = user_activity.groupby(['user_id','activity_type'],as_index = False).agg(
        total_duration = ('activity_duration','sum'),
        total_active_day = ('activity_date','nunique')
    )
    user_activity['total_status'] = user_activity.groupby(['user_id']).activity_type.transform('nunique')
    user_activity = user_activity[user_activity['total_status'] == 2]
    user_activity['avg_duration'] = round(user_activity['total_duration']/user_activity['total_active_day'] + 1e-9,2)
    
    user_activity['trial_avg_duration'] = np.where(user_activity['activity_type'] == 'free_trial',user_activity['avg_duration'],0)
    user_activity['paid_avg_duration'] = np.where(user_activity['activity_type'] == 'paid',user_activity['avg_duration'],0)

    res = user_activity.groupby(['user_id'],as_index = False).agg(
        trial_avg_duration = ('trial_avg_duration','sum'),
        paid_avg_duration = ('paid_avg_duration','sum')
    )
    return res.sort_values('user_id')