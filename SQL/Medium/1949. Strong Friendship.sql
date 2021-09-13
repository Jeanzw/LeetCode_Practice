with friendship as
(select user1_id,user2_id from Friendship
union
 select user2_id,user1_id from Friendship
)
-- 我们之所以用这个cte，因为我们发现对于（1，3）这样的组合，我们3只可以连上6和7，不能连上2，所以我们用一个cte来把所有的情况给列出来


select 
f1.user1_id,
f1.user2_id,
count(distinct f2.user2_id) as common_friend
from friendship f1
join friendship f2 on f1.user1_id = f2.user1_id and f1.user2_id != f2.user2_id
join friendship f3 on f1.user2_id = f3.user1_id and f2.user2_id = f3.user2_id
where f1.user1_id < f1.user2_id
-- 而就因为我们cte的时候把所有的情况给列出来了，也就意味着我们原来Friendship表里面的user1_id < user2_id已经不存在了
-- 所以为了保证result的时候是满足user1_id < user2_id
-- 我们需要在这里用一个where限定范围
group by 1,2
having common_friend >= 3