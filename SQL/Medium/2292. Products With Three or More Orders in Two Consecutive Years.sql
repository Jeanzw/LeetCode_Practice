with summary as
(select 
    product_id, 
    year(purchase_date) as year, 
    count(distinct order_id) as order_num 
from Orders
group by 1,2
having order_num >= 3)
, rnk as
(select product_id, year, row_number() over (partition by product_id order by year) as rnk from summary)

select distinct product_id from rnk
group by 1, year - rnk
having count(*) >= 2