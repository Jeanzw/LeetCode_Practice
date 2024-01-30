-- # Write your MySQL query statement below
select customer_number from orders
group by customer_number
order by count(*) desc
limit 1


-- Follow up: What if more than one customer have the largest number of orders, can you find all the customer_number in this case?
-- 可以用下面的做法做也可以用dense_rank来做
select customer_number from Orders
group by 1
having count(distinct order_number) = 
(select count(distinct order_number) as cnt from Orders
group by customer_number
order by 1 desc limit 1)


-- Python
import pandas as pd

def largest_orders(orders: pd.DataFrame) -> pd.DataFrame:
    # If orders is empty, return an empty DataFrame.
    if orders.empty:
        return pd.DataFrame({'customer_number': []})

    df = orders.groupby('customer_number').size().reset_index(name='count')
    df.sort_values(by='count', ascending = False, inplace=True)
    return df[['customer_number']][0:1]