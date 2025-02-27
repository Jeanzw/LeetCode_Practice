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

-------------------------

-- 用datediff来做
select
distinct a.user_id
from Purchases a
join Purchases b on a.user_id = b.user_id and a.purchase_id != b.purchase_id and datediff(a.purchase_date,b.purchase_date) between 0 and 7
order by 1

-------------------------

--  Python
import pandas as pd

def find_valid_users(purchases: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(purchases,purchases, on = 'user_id')
    merge['diff'] = (merge.purchase_date_x - merge.purchase_date_y).dt.days

    res = merge[(merge['purchase_id_x'] != merge['purchase_id_y'])&(merge['diff'] >= 0)&(merge['diff'] <= 7)]
    return res[['user_id']].sort_values('user_id').drop_duplicates()