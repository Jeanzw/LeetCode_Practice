with summary as
(select
user_id1 as user,
user_id2 as friend 
from Friends
union
select
user_id2 as user,
user_id1 as friend 
from Friends)

-- 下面是改良后的，最开始我其实用了两个join，但是我们其实只需要用一个join就够了
-- 就是找出是具有mutual friend的两个人，我们无所谓这两个人是否是friend
-- 然后再最后一步进行筛选
, with_mutual_friend as
(select distinct a.user as user1, b.user as user2
from summary a
inner join summary b on a.friend = b.friend
)

select 
distinct user_id1,user_id2 from Friends a
left join with_mutual_friend b on a.user_id1 = b.user1 and a.user_id2 = b.user2
where b.user1 is null
order by 1,2

-- , with_mutual_friend as
-- (select distinct a.user, a.friend
-- from summary a
-- inner join summary b on a.user = b.user and a.friend != b.friend
-- inner join summary c on c.user = a.friend and c.friend != a.user and b.user != c.user
-- and c.friend = b.friend
-- )

-- select 
-- distinct user_id1,user_id2 from Friends a
-- left join with_mutual_friend b on a.user_id1 = b.user and a.user_id2 = b.friend
-- where b.user is null
-- order by 1,2