select 
product_id,
sum(quantity) as total_quantity
from Sales
group by 1