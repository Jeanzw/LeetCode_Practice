-- 时间的处理题

select 
distinct a.user_id
from Purchases a
inner join Purchases b 
on a.user_id = b.user_id 
and a.purchase_id != b.purchase_id 
and b.purchase_date between a.purchase_date - interval '7' day and a.purchase_date + interval '7' day
-- 上面时间的处理也可以变成datediff(a.purchase_date,b.purchase_date) between 0 and 7
-- 我们这里选择0 和 7是因为题目中说了at most 7 days apart，如果只是两天最多相差7天那么就是0和6
 order by 1



--  Python
import pandas as pd

def find_valid_users(purchases: pd.DataFrame) -> pd.DataFrame:
    purchases['next_date'] = purchases.sort_values(['user_id','purchase_date']).groupby(['user_id']).purchase_date.shift(1)
    purchases['diff'] = (purchases['next_date'] - purchases['purchase_date']).dt.days.abs()

    res = purchases.query("diff <= 7 and diff >= 0")
    return res[['user_id']].drop_duplicates().sort_values(['user_id'])