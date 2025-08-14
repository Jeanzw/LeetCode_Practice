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

--------------------------------

-- 新的做法
-- 因为我们最后还是要保证原本的user1_id < user2_id，那么我们没必要放弃这个原表
with friend as
(select user1_id as user, user2_id as friend from Friendship
union
select user2_id as user, user1_id as friend from Friendship)

select 
user1_id,
user2_id,
count(distinct b.friend) as common_friend
from Friendship a
-- 利用原表保持原本的数据结构
inner join friend b on a.user1_id = b.user and a.user2_id != b.friend 
-- 链接第一个friends，去找user1的friend
inner join friend c on a.user2_id = c.user and a.user1_id != c.friend and b.friend = c.friend
-- 链接第二个friends，去找user2的friend，并且保证user1的friend和user2的friend一致
group by 1,2
having common_friend >= 3

--------------------------------

-- 新的做法
with frame as
(select user1_id as user_id, user2_id as friend from Friendship
union
select user2_id as user_id, user1_id as friend from Friendship
)

select
distinct a.user_id as user1_id,
a.friend as user2_id,
count(b.friend) as common_friend
from frame a
join frame b on a.friend = b.user_id
join frame c on a.user_id = c.user_id and b.friend = c.friend
group by 1,2
having common_friend >= 3 and user_id < friend

--------------------------------

-- Python
import pandas as pd

def strong_friendship(friendship: pd.DataFrame) -> pd.DataFrame:
    friendship2 = friendship[['user2_id','user1_id']].rename(columns = {'user2_id':'user1_id','user1_id':'user2_id'})
    concat = pd.concat([friendship,friendship2]).drop_duplicates()

    merge = pd.merge(friendship,concat, on = 'user1_id').merge(concat, left_on = ['user2_id_x','user2_id_y'], right_on = ['user1_id','user2_id'])
    merge = merge[merge['user2_id_x'] != merge['user2_id_y']]
    merge = merge.groupby(['user1_id_x','user2_id_x'],as_index = False).user2_id_y.nunique()
    merge = merge[merge['user2_id_y'] >= 3].rename(columns = {'user1_id_x':'user1_id','user2_id_x':'user2_id','user2_id_y':'common_friend'})

    return merge
