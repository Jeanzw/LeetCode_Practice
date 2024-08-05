select
    s.user_id,
    round(ifnull(sum(case when action = 'confirmed' then 1 else 0 end)
    /
    count(*) , 0),2) as confirmation_rate
    from Signups s
    left join Confirmations c on s.user_id = c.user_id
    group by 1



-- Python
import pandas as pd
import numpy as np

def confirmation_rate(signups: pd.DataFrame, confirmations: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(signups,confirmations, on = 'user_id', how = 'left')
    merge['com_action'] = np.where(merge['action'] == 'confirmed', 1, 0)
    summary = merge.groupby(['user_id'], as_index = False).agg(
        den = ('com_action','count'),
        num = ('com_action','sum')
    )
    summary['confirmation_rate'] = (summary['num']/summary['den']).round(2)
    return summary[['user_id','confirmation_rate']]