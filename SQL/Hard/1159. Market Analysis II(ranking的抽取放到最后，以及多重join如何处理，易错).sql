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





-- 上面的query真的太不容易看了
with raw_data as
(select seller_id,fav from
(select 
    seller_id,
    case when item_brand = favorite_brand then 'yes' else 'no' end as fav,
    rank() over (partition by seller_id order by order_date) as rnk
    from Orders o 
    left join Items i on o.item_id = i.item_id
    left join Users u on o.seller_id = u.user_id) tmp
    where rnk = 2)
-- 我们上面的cte其实就是直接去查看是否favorite_brand = item_brand （2nd bought）
-- 其实我们会发现一个问题就是，对于user_id = 1是没有第二次购买的，那么在这种情况下，我们将其定义为no
-- 同时因为userid = 1没有第二次购买，所以上面的cte其实没有办法抽出userid = 1的情况
-- 所以，我们需要另外重新和Users这个tablejoin起来，这样子可以获得所有userid，并且对所有userid进行讨论

select user_id as seller_id,
case when fav is null then 'no' else fav end as '2nd_item_fav_brand'
from Users u 