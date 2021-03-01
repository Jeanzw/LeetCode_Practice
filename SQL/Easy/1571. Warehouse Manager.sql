select 
name as warehouse_name,
sum(Width * Length * Height * units) as volume
-- 在这里可以直接进行处理，而不需要用到cte
from Warehouse w
left join Products p on w.product_id = p.product_id
group by 1