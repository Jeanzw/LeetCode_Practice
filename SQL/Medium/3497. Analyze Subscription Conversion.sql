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

-- 另外的做法
with ft as
(select user_id, round(avg(activity_duration),2) as trial_avg_duration
from UserActivity
where activity_type = 'free_trial'
group by 1)
, paid as
(select user_id, round(avg(activity_duration),2) as paid_avg_duration
from UserActivity
where activity_type = 'paid'
group by 1)

select
a.*, b.paid_avg_duration
from ft a
join paid b on a.user_id = b.user_id
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

-- 另外的做法，更简单
import pandas as pd

def analyze_subscription_conversion(user_activity: pd.DataFrame) -> pd.DataFrame:
    paid = user_activity[user_activity['activity_type'] == 'paid']
    paid = paid.groupby(['user_id'],as_index = False).activity_duration.mean()
    free_trial = user_activity[user_activity['activity_type'] == 'free_trial']
    free_trial = free_trial.groupby(['user_id'],as_index = False).activity_duration.mean()

    merge = pd.merge(free_trial, paid, on = 'user_id').rename(columns = {'activity_duration_x':'trial_avg_duration','activity_duration_y':'paid_avg_duration'})
    merge['trial_avg_duration'] = round(merge['trial_avg_duration'] + 1e-9,2)
    merge['paid_avg_duration'] = round(merge['paid_avg_duration'] + 1e-9,2)
    return merge.sort_values(['user_id'])