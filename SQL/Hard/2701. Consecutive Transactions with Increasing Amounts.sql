-- 这道题目和我们之前连续数的题目不一样的地方在于我们不仅仅是要把对应的customer_id给求出来，而是只要连续就把起止点求出来
-- 但我们逻辑还是和之前一样的，就是要找个bridge
-- 这一道题目的bridge就完全体现了date function的应用了
-- 下面我们是需要用到dateadd的，所以只能在ms sql里面写query，以及在ms sql里面使用datediff(day, A, B) 是B - A的形式

with summary as
(select
distinct a.customer_id,
a.transaction_date as fir,
b.transaction_date as sec,
c.transaction_date as thi,
row_number() over (partition by a.customer_id order by a.transaction_date desc) as rnk
from Transactions a
inner join Transactions b on a.customer_id = b.customer_id and datediff(day,a.transaction_date,b.transaction_date) = 1 and a.amount < b.amount
inner join Transactions c on b.customer_id = c.customer_id and datediff(day,b.transaction_date,c.transaction_date) = 1 and b.amount < c.amount)


select customer_id, min(fir) as consecutive_start, max(thi) as consecutive_end from summary
group by customer_id, dateadd(day, rnk,fir)
order by 1


-- Python
import pandas as pd

def consecutive_increasing_transactions(transactions: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(transactions,transactions,on = 'customer_id').merge(transactions,on = 'customer_id')
    merge['1st_datediff'] = (merge['transaction_date_y'] - merge['transaction_date_x']).dt.days
    merge['2nd_datediff'] = (merge['transaction_date'] - merge['transaction_date_y']).dt.days

    merge = merge[(merge['amount_x'] < merge['amount_y']) & (merge['amount_y'] < merge['amount']) & (merge['1st_datediff'] == 1) & (merge['2nd_datediff'] == 1)]
    merge = merge[['customer_id','transaction_date_x','transaction_date_y','transaction_date']]
    merge['rnk'] = merge.groupby(['customer_id']).transaction_date_x.rank(ascending = False)
    merge['bridge'] = merge['transaction_date_x'] + pd.to_timedelta(merge['rnk'],unit = 'D')

    res = merge.groupby(['customer_id','bridge'],as_index = False).agg(
        consecutive_start = ('transaction_date_x','min'),
        consecutive_end = ('transaction_date','max')
    )
    return res[['customer_id','consecutive_start','consecutive_end']].sort_values('customer_id')