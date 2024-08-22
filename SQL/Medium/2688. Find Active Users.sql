with summary as
(select *, row_number() over () as row_num from Users)

select
distinct a.user_id
from summary a
inner join summary b on a.user_id = b.user_id and datediff(b.created_at,a.created_at) between 0 and 7 and a.row_num != b.row_num



-- 这道题易错的点就在于：可能真的存在同一天同一个人买同样数量的同一个东西
-- | user_id | item              | created_at | amount |
-- | ------- | ----------------- | ---------- | ------ |
-- | 5       | Smart Crock Pot   | 2021-09-18 | 698882 |
-- | 6       | Smart Lock        | 2021-09-14 | 11487  |
-- | 6       | Smart Thermostat  | 2021-09-10 | 674762 |
-- | 8       | Smart Light Strip | 2021-09-29 | 630773 |
-- | 4       | Smart Cat Feeder  | 2021-09-02 | 693545 |
-- | 4       | Smart Cat Feeder  | 2021-09-02 | 693545 |



-- Python
import pandas as pd

def find_active_users(users: pd.DataFrame) -> pd.DataFrame:
    users['ind'] = users.index
    merge = pd.merge(users,users, on = 'user_id')
    merge['day_diff'] = (merge['created_at_x'] - merge['created_at_y']).dt.days
    merge = merge.query("ind_x != ind_y and day_diff >= 0 and day_diff <= 7")
    return merge[['user_id']].drop_duplicates()