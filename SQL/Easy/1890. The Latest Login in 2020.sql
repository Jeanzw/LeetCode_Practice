select user_id,time_stamp as last_stamp
from
(select 
    user_id,
    time_stamp,
    rank() over (partition by user_id order by time_stamp desc) as rnk
    from Logins
    where year(time_stamp) = 2020)tmp
    where rnk = 1

-- 直接用max即可
select
user_id,
max(time_stamp) as last_stamp
from Logins
where year(time_stamp) = 2020
group by 1


-- Python
import pandas as pd

def latest_login(logins: pd.DataFrame) -> pd.DataFrame:
    logins = logins.query("time_stamp.dt.year == 2020")
    logins = logins.groupby(['user_id'],as_index = False).time_stamp.max()
    return logins.rename(columns = {'time_stamp':'last_stamp'})