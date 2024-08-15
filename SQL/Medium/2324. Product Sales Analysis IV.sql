with cte as
(select
a.user_id,
a.product_id,
dense_rank() over (partition by user_id order by sum(quantity) * price desc) as rnk
from Sales a
left join Product b on a.product_id = b.product_id
group by 1,2)

select user_id,product_id from cte where rnk = 1



-- Python
import pandas as pd

def product_sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(sales,product,on = 'product_id')
    merge['summ'] = merge['quantity'] * merge['price']
    summary = merge.groupby(['user_id','product_id'],as_index = False).summ.sum()
    summary['rnk'] = summary.groupby(['user_id']).summ.rank(method = 'dense', ascending = False)
    return summary.query("rnk == 1")[['user_id','product_id']]