with top_first as
(select * from
(select *,
dense_rank() over (partition by product_id order by order_date desc) as rnk
from Orders)tmp
where rnk = 1)

select 
product_name,
top_first.product_id,
order_id,
order_date
from
top_first
left join Products p on top_first.product_id = p.product_id
order by product_name,product_id,order_id

-- 我们可以把rnk = 1放到最后
# Write your MySQL query statement below
with rnk as
(select
a.product_id,
a.product_name,
b.order_id,
b.order_date,
rank() over (partition by a.product_id order by order_date desc) as rnk
from Products a
inner join Orders b on a.product_id = b.product_id)

select product_name,product_id,order_id,order_date
from rnk
where rnk = 1
order by 1,2,3



--  Python
import pandas as pd

def most_recent_orders(customers: pd.DataFrame, orders: pd.DataFrame, products: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(products,orders,on = 'product_id')
    merge['rnk'] = merge.groupby(['product_id']).order_date.rank(method = 'dense', ascending = False)
    merge = merge.query("rnk == 1")
    return merge[['product_name','product_id','order_id','order_date']].sort_values(['product_name','product_id','order_id'])