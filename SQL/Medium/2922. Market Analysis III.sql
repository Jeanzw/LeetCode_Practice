with summary as
(select
a.seller_id,
count(distinct a.item_id) as num_items,
dense_rank() over (order by count(distinct a.item_id) desc) as rnk
from Orders a
left join Items b on a.item_id = b.item_id
inner join Users c on a.seller_id = c.seller_id and b.item_brand != c.favorite_brand 
group by 1)

select seller_id,num_items from summary where rnk = 1
order by 1