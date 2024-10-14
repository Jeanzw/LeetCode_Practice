select distinct page_id as recommended_page from
(
select user1_id as user_id,user2_id as friend from Friendship where user1_id = 1
union all
select user2_id as user_id,user1_id as friend from Friendship where user2_id = 1)tmp
left join Likes l on tmp.friend = l.user_id
where page_id not in
(select page_id from Likes where user_id = 1) and page_id is not null

-- 我在第二次做的时候其实没有做出来，问题就在于，我没考虑用page_id来作为定位，因为我们保证user_id = 1的page_id其实是不能用的，所以需要将此给剔除掉
-- 如果不这样做，其实我们回发现，在Likes里面的6号选手，他的page和1号选手其实是一样的，所以我们需要将此剔除掉


-- 上面的做法还是太复杂了
with friend as
(select distinct user2_id as user_id from Friendship
where user1_id = 1
union all
select distinct user1_id as user_id from Friendship
where user2_id = 1) 
-- 首先我们找到对于user_id = 1的人，他的朋友到底是什么个ID，因为会有duplicate所以我们用distinct
-- 由于是一个双向的过程，所以用union all来找到和user_id是双箭头的

select distinct page_id as recommended_page from Likes
where page_id not in (select page_id from Likes where user_id = 1)
and user_id in (select user_id from friend)
-- 然后需要保证的就是page_id不是在user_id = 1看的page中
-- 同时要保证这些user_id是user_id = 1的朋友






-- 或者把user_id = 1的处理放到最后
with friend as
(select 
user1_id as user_id,
 user2_id as friend_id
 from Friendship
 union --用union比较好，因为可以提出重复值
 select 
 user2_id as user_id,
 user1_id as friend_id
 from Friendship
)

select
distinct page_id as recommended_page
from Likes l 
join friend f on l.user_id = f.friend_id and f.user_id = 1
where page_id not in (select page_id from Likes where user_id = 1)


-- 个人不推荐用not in来做
# Write your MySQL query statement below
with cte as
(select user1_id as userid, user2_id as friend from Friendship
where user1_id = 1
union
select user2_id as userid, user1_id as friend from Friendship
where user2_id = 1
)
, user1_like as
(select distinct page_id from Likes where user_id = 1)


select 
distinct b.page_id as recommended_page
from cte a
inner join Likes b on a.friend = b.user_id
left join user1_like c on b.page_id = c.page_id
where c.page_id is null


-- 或者就是每一步清楚地写出来，最后用page_id来做定位
with frame as
(select user1_id as users, user2_id as friend from Friendship
union
select user2_id as users, user1_id as friend from Friendship
)
, friend_like as
(select 
distinct page_id
from frame a
inner join Likes b on a.users = 1 and a.friend = b.user_id)
, user_like as
(select distinct page_id from Likes where user_id = 1)

select distinct a.page_id as recommended_page from friend_like a
left join user_like b on a.page_id = b.page_id
where b.page_id is null



-- Python
import pandas as pd

def page_recommendations(friendship: pd.DataFrame, likes: pd.DataFrame) -> pd.DataFrame:
    friendship1 = friendship[['user1_id','user2_id']].rename(columns = {'user1_id':'user','user2_id':'friend'})
    friendship2 = friendship[['user2_id','user1_id']].rename(columns = {'user2_id':'user','user1_id':'friend'})
    concat = pd.concat([friendship1,friendship2]).query("user == 1")

    user1_like = likes.query("user_id == 1")
    friend_like = pd.merge(concat,likes,left_on = 'friend',right_on = 'user_id')

    res = pd.merge(friend_like,user1_like,on = 'page_id',how = 'left').query("user_id_y.isna()")[['page_id']].drop_duplicates()
    return res.rename(columns = {'page_id':'recommended_page'})