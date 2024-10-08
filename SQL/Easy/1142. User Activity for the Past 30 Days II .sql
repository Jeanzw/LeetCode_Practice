select ifnull(round(count(session_id)/count(distinct user_id),2),0) as  average_sessions_per_user from
(select user_id,session_id from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by 1,2)tmp

-- 这道题注意可能会有null的情况存在
select ifnull(round(count(distinct session_id)/count(distinct user_id),2),0.00) as average_sessions_per_user from Activity
where datediff('2019-07-27',activity_date) < 30

-- 这道题之后再做我是这样的
-- 当时考虑，可能同一个session会在不同的userid中出现，这是因为我忽略了题目中的：
-- Note that each session belongs to exactly one user.
-- 有了这个条件后，我们可以直接对原表count distinct了，而不需要先求出各个user自己的session num，然后再去求比例了
select ifnull(round(sum(num_session)/count(distinct user_id),2),0.00) as average_sessions_per_user from
(select 
user_id,
count(distinct session_id) as num_session
from Activity
where datediff('2019-07-27',activity_date) <30
group by 1)tmp


-- Python
import pandas as pd
import numpy as np

def user_activity(activity: pd.DataFrame) -> pd.DataFrame:
    activity['flg'] = np.where((activity['activity_date'] >= pd.to_datetime('2019-07-27') - pd.to_timedelta(29,unit = 'd')) & (activity['activity_date'] <= pd.to_datetime('2019-07-27')),1,0
    )
    activity = activity.query("flg == 1")
    n = activity.session_id.nunique()
    d = activity.user_id.nunique()
    if d == 0:
        return pd.DataFrame({'average_sessions_per_user':[0]})
    else:
        return pd.DataFrame({'average_sessions_per_user':[round(n/d,2)]})