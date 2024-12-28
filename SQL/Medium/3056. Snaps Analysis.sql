select
b.age_bucket,
ifnull(round(100* sum(case when activity_type = 'send' then time_spent end)/sum(time_spent),2),0) as send_perc,
ifnull(round(100* sum(case when activity_type = 'open' then time_spent end)/sum(time_spent),2),0) as open_perc
from Activities a
left join Age b on a.user_id = b.user_id
group by 1


-- Python
import pandas as pd
import numpy as np

def snap_analysis(activities: pd.DataFrame, age: pd.DataFrame) -> pd.DataFrame:
    activities['open'] = np.where(activities['activity_type'] == 'open',activities['time_spent'],0)
    activities['send'] = np.where(activities['activity_type'] == 'send',activities['time_spent'],0)

    merge = pd.merge(age,activities, on = 'user_id', how = 'left')

    merge = merge.groupby(['age_bucket'],as_index = False).agg(
        total = ('time_spent','sum'),
        open = ('open','sum'),
        send = ('send','sum')
    )

    merge['send_perc'] = round(100 * merge['send']/merge['total'],2)
    merge['open_perc'] = round(100 * merge['open']/merge['total'],2)

    return merge[['age_bucket','send_perc','open_perc']]