with subscription_2021 as
(select
distinct account_id
from Subscriptions
where year(start_date) = 2021 or year(end_date) = 2021 or (year(start_date) < 2021 and year(end_date) > 2021))
, session_2021 as
(select distinct account_id from Streams where year(stream_date) = 2021)

select
count(distinct a.account_id) as accounts_count
from subscription_2021 a
left join session_2021 b on a.account_id = b.account_id
where b.account_id is null


-- 不需要写cte
select 
count(distinct a.account_id) as accounts_count
from Subscriptions a
left join Streams b on a.account_id = b.account_id and year(stream_date) = 2021
where (year(start_date) = 2021 or year(end_date) = 2021 or (year(start_date) < 2021 and year(end_date) > 2021))
and b.account_id is null


-- Python
import pandas as pd
import numpy as np

def find_target_accounts(subscriptions: pd.DataFrame, streams: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(subscriptions,streams,on = 'account_id',how = 'left')
    merge['active_subs_2021'] = np.where(merge['start_date'].dt.year == 2021, 1, 
    np.where(merge['end_date'].dt.year == 2021,1,
    np.where((merge['end_date'].dt.year > 2021) & (merge['start_date'].dt.year < 2021), 1, 0)))
    merge['stream_2021'] = np.where(merge['stream_date'].dt.year == 2021, 1, 0)

    res = merge.query("active_subs_2021 == 1 and stream_2021 == 0")
    return pd.DataFrame({'accounts_count': [len(res)]})