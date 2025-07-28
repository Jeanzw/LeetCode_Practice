select customer_id,name from Customers c
where customer_id in
(select customer_id from
(select customer_id, month(order_date) as month, sum(price * quantity) as amount from Product p
join Orders  o on p.product_id = o.product_id
where order_date between '2020-06-01' and '2020-07-31'
group by 1,2
having amount >= 100)tmp
group by 1
having count(*) = 2)

----------------------------------

-- 和上面的思路一样，但是用cte会比较清楚
with expense as
(select 
 o.customer_id,
 date_format(order_date,'%m-%Y') as day,
 sum(price*quantity) as expense
 from Orders o left join Product p on o.product_id = p.product_id
where order_date between '2020-06-01' and '2020-07-31'
 group by 1,2
having expense >= 100)
-- 先求出花销大于100的
, customers_more_than_100 as
(select customer_id from expense group by 1 having count(*) = 2)
-- 然后找出在6月和7月都花销大于100的customer id
select customer_id,name from Customers
where customer_id in (select * from customers_more_than_100)

----------------------------------

-- 另外的做法
-- 我觉得这种方法是最好的诶
-- 就是我们相当于所有的customer都有对应的6月份和7月份的消费，如果没有我们就当做是0
-- 然后我们只需要保证这两个月的消费同时多于100即可
SELECT customer_id, name
FROM (
    SELECT c.customer_id, c.name, 
    SUM(CASE WHEN LEFT(o.order_date, 7) = '2020-06' THEN p.price*o.quantity ELSE 0 END) AS t1, 
    SUM(CASE WHEN LEFT(o.order_date, 7) = '2020-07' THEN p.price*o.quantity ELSE 0 END) AS t2
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN product p
    ON p.product_id = o.product_id
    GROUP BY 1
    ) tmp
WHERE t1 >= 100 AND t2 >= 100

----------------------------------

-- Python
import pandas as pd

def customer_order_frequency(customers: pd.DataFrame, product: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    orders = orders[(orders['order_date'] >= '2020-06-01') & (orders['order_date'] <= '2020-07-31')]
    orders['month'] = orders.order_date.dt.month
    order_product = pd.merge(orders,product, on = 'product_id')
    order_product['money'] = order_product['quantity'] * order_product['price']
    order_product = order_product.groupby(['customer_id','month'],as_index = False).money.sum()
    order_product = order_product[order_product['money'] >= 100]
    order_product = order_product.groupby(['customer_id'],as_index = False).month.nunique()
    order_product = order_product[order_product['month'] == 2]

    res = pd.merge(order_product,customers, on = 'customer_id')[['customer_id','name']]
    return res