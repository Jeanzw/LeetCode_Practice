select 
-- 要非常注意，分子是sum而不是count，不然永远都是6，因为一共有6个delivery_id需要判断
round(sum(order_date = customer_pref_delivery_date) * 100
/
count(delivery_id),2) as immediate_percentage
from Delivery