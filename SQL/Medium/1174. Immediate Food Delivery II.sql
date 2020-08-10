select 
round(100* sum(case when order_date = customer_pref_delivery_date then 1.0 else 0 end)
/
count(distinct customer_id), 2) as immediate_percentage
from
(select *, rank() over (partition by customer_id order by order_date) as rnk from Delivery)tmp
where rnk = 1