select
user_id,
sum(quantity * price) as spending
from Sales a
left join Product b on a.product_id = b.product_id
group by 1
order by 2 desc, 1

----------------------

-- Python
import pandas as pd

def product_sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(sales,product,on = 'product_id')
    merge['spending'] = merge['quantity'] * merge['price']
    summary = merge.groupby(['user_id'],as_index = False).spending.sum()
    return summary.sort_values(['spending','user_id'], ascending = [0,1])