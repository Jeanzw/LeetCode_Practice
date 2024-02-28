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


-- 我就感觉这道题没必要用cte……太麻烦了
select product_name,product_id,order_id,order_date from
(select 
 product_name,
 o.product_id,
 o.order_id,
 order_date,
 dense_rank() over (partition by o.product_id order by order_date desc) as rnk
 from Orders o
 left join Products p on o.product_id = p.product_id)tmp
 where rnk = 1
 order by product_name ,product_id,order_id


--  Python
import pandas as pd
​
def most_recent_orders(customers: pd.DataFrame, orders: pd.DataFrame, products: pd.DataFrame) -> pd.DataFrame:

    df = orders.merge(products, on='product_id').reset_index()

    df = df.groupby('product_id').apply(lambda x:x[x.order_date == x.order_date.max()]).reset_index(drop=True)

    return df[['product_name', 'product_id', 'order_id', 'order_date']].sort_values(['product_name', 'product_id', 'order_id'])