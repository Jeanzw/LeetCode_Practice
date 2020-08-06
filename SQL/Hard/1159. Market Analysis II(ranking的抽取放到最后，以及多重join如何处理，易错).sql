select u.user_id as seller_id,
(case when favorite_brand = item_brand then 'yes' else 'no' end) as '2nd_item_fav_brand'
from
Users u 

left join

(select seller_id, item_brand,rank() over (partition by seller_id order by order_date ) as ranking from Orders a
left join 
 Items i on a.item_id = i.item_id)b
 /*我们此处相当于先把除去第一个Users表中的内容给处理掉，但是抽取什么的都不管先，只管对应关系*/

 on u.user_id = b.seller_id and b.ranking = 2
 /*最后抽取ranking的内容*/


--  我第二次做的时候是：
select user_id as seller_id,
case when seller_id is not null and favorite_brand = item_brand then 'yes' else 'no' end as 2nd_item_fav_brand
from Users u
left join (select seller_id,item_id, rank() over (partition by seller_id order by order_date) as rnk from Orders) a
on u.user_id = a.seller_id and a.rnk = 2
left join Items i
on a.item_id = i.item_id
-- 我们的rnk抽取在join的时候已经完成了，为的就是保留Users里面全部的user_id