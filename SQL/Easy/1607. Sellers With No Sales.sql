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
left join Orders o on s.seller_id = o.seller_id 
    and year(sale_date) = 2020
-- 我们一定要注意2020的filter一定要在on里面完成而不能转移到where，因为只有在on里面完成才能保全seller这一张表，不然连不上的内容就会在where里面被挪走
where o.seller_id is null
order by 1