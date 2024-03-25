select
a.salesperson_id,
a.name,
ifnull(sum(price),0) as total
from Salesperson a
left join Customer b on a.salesperson_id = b.salesperson_id
left join Sales c on b.customer_id = c.customer_id
group by 1,2