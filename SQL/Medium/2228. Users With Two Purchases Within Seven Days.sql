-- 时间的处理题

select 
distinct a.user_id
from Purchases a
inner join Purchases b 
on a.user_id = b.user_id 
and a.purchase_id != b.purchase_id 
and b.purchase_date between a.purchase_date - interval '7' day and a.purchase_date + interval '7' day
-- 上面时间的处理也可以变成datediff(a.purchase_date,b.purchase_date) between 0 and 7
 order by 1