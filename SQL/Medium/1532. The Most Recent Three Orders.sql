select name as customer_name, tmp.customer_id, order_id, order_date from
(select 
    customer_id, 
    order_id, 
    order_date, 
    rank() over(partition by customer_id order by order_date desc) as rnk from Orders)tmp
join Customers c on tmp.customer_id = c.customer_id
where rnk <= 3
order by name, customer_id, order_date desc


-- Python
import pandas as pd

def recent_three_orders(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(orders,customers, on = 'customer_id').sort_values(['name','customer_id','order_date'], ascending = [True, True,False]).groupby(['name','customer_id']).head(3)

    return merge[['name','customer_id','order_id','order_date']].rename(columns = {'name':'customer_name'})