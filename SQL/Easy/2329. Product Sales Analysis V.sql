select
user_id,
sum(quantity * price) as spending
from Sales a
left join Product b on a.product_id = b.product_id
group by 1
order by 2 desc, 1