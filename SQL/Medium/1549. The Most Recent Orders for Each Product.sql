with top_first as
(select * from
(select *,
dense_rank() over (partition by product_id order by order_date desc) as rnk
from Orders)tmp
where rnk = 1)

select 
product_name,
top_first.product_id,
order_id,
order_date
from
top_first
left join Products p on top_first.product_id = p.product_id
order by product_name,product_id,order_id
