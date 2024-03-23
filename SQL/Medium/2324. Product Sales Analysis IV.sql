with cte as
(select
a.user_id,
a.product_id,
dense_rank() over (partition by user_id order by sum(quantity) * price desc) as rnk
from Sales a
left join Product b on a.product_id = b.product_id
group by 1,2)

select user_id,product_id from cte where rnk = 1