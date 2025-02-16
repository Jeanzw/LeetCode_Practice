select distinct a.account_id
from LogInfo a
join LogInfo b 
on a.account_id = b.account_id 
and a.ip_address != b.ip_address 
and ((a.login between b.login and b.logout) or (b.login between a.login and a.logout))

---------------------------------

-- 其实对于时间的filter要一个就够了
select
distinct a.account_id
from LogInfo a
join LogInfo b 
on a.account_id = b.account_id 
and a.ip_address != b.ip_address 
and (b.login between a.login and a.logout)

---------------------------------

-- Python
import pandas as pd

def leetflex_banned_accnts(log_info: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(log_info,log_info,how = 'cross')
    merge = merge[(merge['account_id_x'] == merge['account_id_y']) & (merge['ip_address_x'] != merge['ip_address_y']) & (merge['login_y'] >= merge['login_x']) & (merge['login_y'] <= merge['logout_x'])]
    return merge[['account_id_x']].drop_duplicates().rename(columns = {'account_id_x':'account_id'})