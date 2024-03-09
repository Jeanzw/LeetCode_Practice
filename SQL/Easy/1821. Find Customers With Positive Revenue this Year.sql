select
customer_id
from Customers
where year = 2021 
group by 1 
having sum(revenue) > 0