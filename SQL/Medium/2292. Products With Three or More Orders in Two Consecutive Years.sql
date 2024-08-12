with summary as
(select 
    product_id, 
    year(purchase_date) as year, 
    count(distinct order_id) as order_num 
from Orders
group by 1,2
having order_num >= 3)
, rnk as
(select product_id, year, row_number() over (partition by product_id order by year) as rnk from summary)

select distinct product_id from rnk
group by 1, year - rnk
having count(*) >= 2



-- Python
import pandas as pd

def find_valid_products(orders: pd.DataFrame) -> pd.DataFrame:
    orders['year'] = orders.purchase_date.dt.year
    orders = orders.groupby(['product_id','year'], as_index = False).order_id.nunique()
    orders = orders.query("order_id >= 3")
    orders['rnk'] = orders.groupby(['product_id']).year.rank()
    orders['bridge'] =orders['year'] - orders['rnk']

    summary = orders.groupby(['product_id','bridge'],as_index = False).year.nunique()
    summary = summary.query("year >= 2")

    return summary[['product_id']].drop_duplicates()