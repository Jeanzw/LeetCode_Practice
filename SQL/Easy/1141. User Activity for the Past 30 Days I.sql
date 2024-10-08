select activity_date as day, count(distinct user_id) as active_users from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date


-- 另外的做法：用datediff
select 
    activity_date as day,
    count(distinct user_id) as active_users
    from Activity 
where datediff('2019-07-27',activity_date) between 0 and 29
-- 我们一定要是有0的存在，不然就可能存在activity_date在2019-07-27之后的情况了
group by 1


-- Python
import pandas as pd
import numpy as np

def user_activity(activity: pd.DataFrame) -> pd.DataFrame:
    activity['flg'] = np.where((activity['activity_date'] > (pd.to_datetime('2019-07-27') - pd.to_timedelta(30,unit = 'd'))) & (activity['activity_date'] <= pd.to_datetime('2019-07-27')),1,0)
    activity = activity.query("flg == 1")
    activity = activity.groupby(['activity_date'],as_index = False).user_id.nunique()
    return activity.rename(columns = {'activity_date':'day','user_id':'active_users'})