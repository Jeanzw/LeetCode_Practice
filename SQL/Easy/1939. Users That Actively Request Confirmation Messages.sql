select
distinct a.user_id
from Confirmations a
join Confirmations b on a.user_id = b.user_id and a.time_stamp < b.time_stamp
where TIMESTAMPDIFF(SECOND,a.time_stamp,b.time_stamp) <= 


-- Python
import pandas as pd

def find_requesting_users(signups: pd.DataFrame, confirmations: pd.DataFrame) -> pd.DataFrame:
    confirmations = confirmations.sort_values(['user_id','time_stamp'])
    confirmations['prev_line'] = confirmations['time_stamp'].shift(-1)
    confirmations = confirmations.query("~prev_line.isna()")
    confirmations['diff'] = (confirmations['prev_line'] - confirmations['time_stamp']).dt.total_seconds()
    return confirmations.query("diff <= 86400 and diff > 0")[['user_id']].drop_duplicates()