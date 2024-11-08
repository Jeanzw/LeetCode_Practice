--我自己写的
with max_order as
(select order_id,max(quantity) as quantity from OrdersDetails
group by 1)
, average_order as
(select order_id,sum(quantity)/count(distinct product_id) as average from OrdersDetails
group by 1)

select 
 order_id
 from max_order
 where quantity > (select max(average) from average_order)


-- 别人做的
-- 其实逻辑是一样的，只不过他这里写的相当于默认product id出现的次数就是一次，所以可以直接用avg来求平均值
WITH tb1 AS (
SELECT order_id,
AVG(quantity) AS avg_quantity,
MAX(quantity) AS max_quantity
FROM OrdersDetails
GROUP BY order_id
)

SELECT order_id
FROM tb1
WHERE max_quantity > (SELECT MAX(avg_quantity) AS max_avg_quantity
FROM tb1)


-- 我们还是可以用window function来做
with cte as
(select *, max(quantity) over (partition by order_id) as max_quantity, avg(quantity) over (partition by order_id) as avg_quantity from OrdersDetails)

select
distinct order_id
from cte
where max_quantity > (select max(avg_quantity) from cte)


-- Python
import pandas as pd

def orders_above_average(orders_details: pd.DataFrame) -> pd.DataFrame:
    summary = orders_details.groupby(['order_id'],as_index = False).agg(
        max_quantity = ('quantity','max'),
        avg_quantity = ('quantity','mean')
    )
    summary['max_avg_quantity'] = summary.avg_quantity.max()
    return summary.query("max_quantity > max_avg_quantity")[['order_id']]