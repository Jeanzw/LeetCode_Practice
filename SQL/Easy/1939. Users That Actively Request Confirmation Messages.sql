select
distinct a.user_id
from Confirmations a
join Confirmations b on a.user_id = b.user_id and TIMESTAMPDIFF(SECOND,a.time_stamp,b.time_stamp) between 1 and 86400


-- Python
import pandas as pd

def find_requesting_users(signups: pd.DataFrame, confirmations: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(confirmations,confirmations, on = 'user_id')
    merge = merge.query("(time_stamp_x - time_stamp_y).dt.total_seconds() >= 1 and (time_stamp_x - time_stamp_y).dt.total_seconds() <= 86400")
    return merge[['user_id']].drop_duplicates()