select date_format(order_date,'%Y-%m') as month,
count(distinct order_id) as order_count,
count(distinct customer_id) as customer_count
from Orders
where invoice > 20
group by 1

------------------------------------

-- Python
import pandas as pd

def unique_orders_and_customers(orders: pd.DataFrame) -> pd.DataFrame:
    orders['month'] = orders.order_date.dt.strftime('%Y-%m')
    orders = orders[orders['invoice'] > 20]
    orders = orders.groupby(['month'],as_index = False).agg(
        order_count = ('order_id','nunique'),
        customer_count = ('customer_id','nunique')
    )
    return orders