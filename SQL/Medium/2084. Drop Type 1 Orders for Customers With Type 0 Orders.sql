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