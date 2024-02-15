select p.product_id,
round(sum(price * units)/sum(units),2) as average_price

from Prices p
left join UnitsSold u
on p.product_id = u.product_id 
and u.purchase_date between p.start_date and p.end_date
group by 1


-- 上面的用法通过不了了，因为新的版本我们是想要完全保留Prices就算里面没有卖出去任何一件物品，那么返回0
select
a.product_id,
ifnull(round(sum(price * units)/sum(units),2),0) as average_price
from Prices a
left join UnitsSold b on a.product_id = b.product_id and purchase_date between start_date and end_date
group by 1