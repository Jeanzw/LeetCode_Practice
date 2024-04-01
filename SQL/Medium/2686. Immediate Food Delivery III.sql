select
order_date,
round(100* count(distinct case when order_date = customer_pref_delivery_date then delivery_id end)
/
count(distinct delivery_id),2) as immediate_percentage
from Delivery 
group by 1
order by 1