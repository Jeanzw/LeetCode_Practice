-- mysql
select seller_id from Sales 
group by 1
having sum(price) =
(select sum(price) from Sales
group by seller_id
order by sum(price) desc limit 1)

-- MS sql
select seller_id from
(select seller_id, rank() over(order by sum(price) desc) as rank
from sales group by seller_id) b
where rank = 1