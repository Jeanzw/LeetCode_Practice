with type0 as
(select distinct customer_id from Orders where order_type = 0)

select
a.*
from Orders a
left join type0 b on a.customer_id = b.customer_id
where b.customer_id is not null and order_type != 1

union all

select
a.*
from Orders a
left join type0 b on a.customer_id = b.customer_id
where b.customer_id is null


-- 或者
SELECT order_id, customer_id, order_type
FROM Orders
WHERE 
	order_type = 0 or 
	(order_type = 1 and customer_id not in (
		SELECT customer_id
		FROM Orders
		WHERE order_type = 0)
	)


-- 或者用一个window function来判断是否有0
with cte as
(select
*,
min(order_type) over (partition by customer_id) as flg
from Orders)

select order_id,customer_id,order_type from cte where flg = 0 and order_type = 0
union
select order_id,customer_id,order_type from cte where flg != 0


-- Python
import pandas as pd

def drop_specific_orders(orders: pd.DataFrame) -> pd.DataFrame:
    orders['flg'] = orders.groupby(['customer_id']).order_type.transform(min)
    flg_0 = orders.query("order_type != 1 and flg == 0")[['order_id','customer_id','order_type']]
    flg_1 = orders.query("flg == 1")[['order_id','customer_id','order_type']]

    return pd.concat([flg_0,flg_1])