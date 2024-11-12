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
    subscriptions['flg'] = np.where(subscriptions.start_date.dt.year == 2021, 1,
                           np.where(subscriptions.end_date.dt.year == 2021, 1,
                           np.where((subscriptions.start_date.dt.year < 2021) & (subscriptions.end_date.dt.year) > 2021,1,0)))
    subscriptions = subscriptions.query("flg == 1")
    streams = streams.query("stream_date.dt.year == 2021")

    merge = pd.merge(subscriptions,streams,on = 'account_id',how = 'left').query("session_id.isna()")
    res = merge.account_id.nunique()
    return pd.DataFrame({'accounts_count':[res]})