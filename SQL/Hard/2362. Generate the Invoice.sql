with cte as
(select
invoice_id,
sum(quantity * price) as tt
from Purchases a
left join Products b on a.product_id = b.product_id
group by 1
order by 2 desc, 1
limit 1)

select 
a.product_id,a.quantity,price * quantity as price
from Purchases a
inner join cte b on a.invoice_id = b.invoice_id
left join Products c on a.product_id = c.product_id