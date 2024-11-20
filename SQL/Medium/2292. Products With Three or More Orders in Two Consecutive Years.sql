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


-- 其实我觉得这道题不需要按照之前找连续数这样做，这样太复杂了
with cte as
(select
year(purchase_date) as year,
product_id
from Orders
group by 1,2
having count(distinct order_id) >= 3)

select
distinct a.product_id
from cte a
inner join cte b on a.product_id = b.product_id and a.year + 1 = b.year



-- Python
import pandas as pd

def find_valid_products(orders: pd.DataFrame) -> pd.DataFrame:
    orders['year'] = orders.purchase_date.dt.year

    summary = orders.groupby(['year','product_id'],as_index = False).order_id.nunique()
    summary = summary[summary['order_id'] >= 3]

    merge = pd.merge(summary,summary,on = 'product_id')
    merge = merge[merge['year_x'] + 1 == merge['year_y']]
    return merge[['product_id']].drop_duplicates()