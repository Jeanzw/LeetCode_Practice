select 
name as warehouse_name,
sum(Width * Length * Height * units) as volume
from Warehouse w
left join Products p on w.product_id = p.product_id
group by 1