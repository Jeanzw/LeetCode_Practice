select
    s.user_id,
    round(ifnull(sum(case when action = 'confirmed' then 1 else 0 end)
    /
    count(*) , 0),2) as confirmation_rate
    from Signups s
    left join Confirmations c on s.user_id = c.user_id
    group by 1

---------------------------

-- Python
import pandas as pd
import numpy as np
def confirmation_rate(signups: pd.DataFrame, confirmations: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(signups, confirmations, on = 'user_id', how = 'left')
    merge['confirmed'] = np.where(merge['action'] == 'confirmed', merge['user_id'], None)
    merge = merge.groupby(['user_id'],as_index = False).agg(
        d = ('user_id','count'),
        n = ('confirmed','count')
    )
    merge['confirmation_rate'] = np.where(merge['d'] == 0, 0, round(merge['n']/merge['d'],2))
    return merge[['user_id','confirmation_rate']]

---------------------------

-- 另外的做法
import pandas as pd
import numpy as np

def confirmation_rate(signups: pd.DataFrame, confirmations: pd.DataFrame) -> pd.DataFrame:
    confirm = confirmations[confirmations['action'] == 'confirmed']
    confirm = confirm.groupby(['user_id'],as_index = False).size()
    request = confirmations.groupby(['user_id'],as_index = False).size()

    merge = pd.merge(signups,request, on = 'user_id', how = 'left').merge(confirm, on = 'user_id', how = 'left').fillna(0)
    merge['confirmation_rate'] = np.where(merge['size_x'] == 0, 0, round(merge['size_y']/merge['size_x'],2))
    return merge[['user_id','confirmation_rate']]