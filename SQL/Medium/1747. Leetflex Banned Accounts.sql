select distinct a.account_id
from LogInfo a
join LogInfo b 
on a.account_id = b.account_id 
and a.ip_address != b.ip_address 
and ((a.login between b.login and b.logout) or (b.login between a.login and a.logout))

-- 其实对于时间的filter要一个就够了
select
distinct a.account_id
from LogInfo a
join LogInfo b 
on a.account_id = b.account_id 
and a.ip_address != b.ip_address 
and (b.login between a.login and a.logout)


-- Python
import pandas as pd

def leetflex_banned_accnts(log_info: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(log_info,log_info, on = 'account_id')
    merge = merge.query("ip_address_x != ip_address_y and login_x >= login_y and login_x <= logout_y")
    return merge[['account_id']].drop_duplicates()