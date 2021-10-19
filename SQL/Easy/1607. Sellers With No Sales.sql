select seller_name from Seller 
where seller_id not in
(
select distinct seller_id from Orders
where year(sale_date) = 2020)
order by 1

-- 也可以用left join来做这道题
select
distinct s.seller_name
from Seller s
left join Orders o on s.seller_id = o.seller_id and year(sale_date) = 2020
where o.seller_id is null
order by 1