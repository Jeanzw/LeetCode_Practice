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


-- Python
import pandas as pd

def customer_order_frequency(
    customers: pd.DataFrame, product: pd.DataFrame, orders: pd.DataFrame
) -> pd.DataFrame:

    # Merge and filter for year 2020
    merged_df = pd.merge(
        pd.merge(orders, customers, on="customer_id"), product, on="product_id"
    )
    merged_df["order_date"] = pd.to_datetime(merged_df["order_date"])
    merged_df = merged_df[merged_df["order_date"].dt.year == 2020]

    # Group by customer_id and calculate monthly sums
    grouped = merged_df.groupby(["customer_id", merged_df["order_date"].dt.month])
    monthly_sums = grouped.apply(lambda x: (x["quantity"] * x["price"]).sum()).unstack()

    # Filter for customers meeting criteria in both June (6) and July (7)
    valid_customers = monthly_sums[
        (monthly_sums[6] >= 100) & (monthly_sums[7] >= 100)
    ].index

    # Final DataFrame with customer details
    result = customers[customers["customer_id"].isin(valid_customers)]

    return result[["customer_id", "name"]]
