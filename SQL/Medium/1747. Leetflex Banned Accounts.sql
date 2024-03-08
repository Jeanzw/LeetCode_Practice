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
    # Approach: .merge(cross) and filter
    df = log_info.merge(log_info, how="cross")

    # Filter rows that have same account_id, different ip_address, and overlapped logged in times.
    df = df[df['account_id_x'] == df['account_id_y']]
    df = df[df['ip_address_x'] != df['ip_address_y']]
    df = df[(df['login_x'] <= df['logout_y']) & (df['login_y'] <= df['logout_x'])]
    
    # Drop duplicates on account_id
    df = df.drop_duplicates('account_id_x')

    # Rename output column
    df = df.rename(columns={'account_id_x': 'account_id'})

    return df[['account_id']]