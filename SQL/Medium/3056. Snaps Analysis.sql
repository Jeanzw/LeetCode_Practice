select
b.age_bucket,
ifnull(round(100* sum(case when activity_type = 'send' then time_spent end)/sum(time_spent),2),0) as send_perc,
ifnull(round(100* sum(case when activity_type = 'open' then time_spent end)/sum(time_spent),2),0) as open_perc
from Activities a
left join Age b on a.user_id = b.user_id
group by 1


-- Python
import pandas as pd

def snap_analysis(activities: pd.DataFrame, age: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(age,activities,on = 'user_id', how = 'left')
    
    summary = merge.groupby(['age_bucket','activity_type'],as_index = False).time_spent.sum()
    summary['total_time'] = summary.groupby(['age_bucket']).time_spent.transform(sum)
    summary['pct'] = round(100 * summary['time_spent']/summary['total_time'],2)
    open_ = summary.query("activity_type == 'open'")
    send_ = summary.query("activity_type == 'send'")
    result = pd.merge(send_,open_, on = 'age_bucket', how = 'left').fillna(0)
    return result[['age_bucket','pct_x','pct_y']].rename(columns = {'pct_x':'send_perc','pct_y':'open_perc'})