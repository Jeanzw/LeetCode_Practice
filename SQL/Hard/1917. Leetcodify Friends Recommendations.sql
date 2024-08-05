-- 我觉得对于超时的问题我们还得继续研究一下
-- 因为下面第一个解法显示的是超时，因为我们直接用了not in，这个不高效我可以理解
select 
distinct l1.user_id,  --注意我们这里一定要加distinct，因为我们group by里面还有一个day
-- 比如说A和B两天都有两首歌一样，那么我们不加distinct的情况下，AB成recommend的行数会出现两次
-- 但是我们返回的只需要返回一次即可，所以这里需要加一个distinct
l2.user_id as recommended_id
from Listens l1
join Listens l2 on l1.user_id != l2.user_id and l1.song_id = l2.song_id and l1.day = l2.day
where (l1.user_id,l2.user_id) not in (select user1_id,user2_id from Friendship) and
(l2.user_id,l1.user_id) not in (select user1_id,user2_id from Friendship)
group by 1,2,l1.day
having count(distinct l1.song_id) >= 3

-- 但是下面这种做法还是超时
-- 也就是说我们如果用left join但是是在连接条件上有很多条件其实也是不高效的
select 
distinct l1.user_id,
l2.user_id as recommended_id
from Listens l1
join Listens l2 on l1.user_id != l2.user_id and l1.song_id = l2.song_id and l1.day = l2.day
left join Friendship f on (l1.user_id = f.user1_id and l2.user_id = f.user2_id) or (l2.user_id = f.user1_id and l1.user_id = f.user2_id)
where f.user1_id is null
group by 1,2,l1.day
having count(distinct l1.song_id) >= 3


-- 下面这种做法其实就可以通过了
-- 相当于我们是把friendship这张表用union all处理了一下，从而在left join的时候系统不需要去判断or的情况只需要直接一行行扫下来即可
-- 而且我们这里用了union，相当于是直接把重复值给全部筛除了
with friend as
(select user1_id, user2_id from Friendship
union 
select user2_id, user1_id from Friendship
)

select 
distinct l1.user_id,
l2.user_id as recommended_id
from Listens l1
join Listens l2 on l1.user_id != l2.user_id and l1.song_id = l2.song_id and l1.day = l2.day
-- 因为我们第一个限定就是两人要听一样的至少三首歌，所以可以直接用listens这个表进行筛选出这个条件
left join friend f on l1.user_id = f.user1_id and l2.user_id = f.user2_id
-- 然后用left join来对friend进行筛选
-- 这里还是需要用left join而不是not in，因为为了保持高效性
where f.user1_id is null
group by 1,2,l1.day
having count(distinct l1.song_id) >= 3



-- Python
import pandas as pd

def recommend_friends(listens: pd.DataFrame, friendship: pd.DataFrame) -> pd.DataFrame:
    user1 = friendship[['user1_id','user2_id']].rename(columns = {'user1_id':'user_id','user2_id':'friend'})
    user2 = friendship[['user2_id','user1_id']].rename(columns = {'user2_id':'user_id','user1_id':'friend'})
    user = pd.concat([user1,user2]).drop_duplicates()
    merge = pd.merge(listens,listens, on = ['song_id','day']).query("user_id_x != user_id_y")
    summary = pd.merge(merge,user,left_on = ['user_id_x','user_id_y'], right_on = ['user_id','friend'],how = 'left', indicator = False).query("user_id.isna()")
    summary = summary.groupby(['user_id_x','user_id_y','day'], as_index = False).song_id.nunique()
    return summary.query("song_id >= 3")[['user_id_x','user_id_y']].rename(columns = {'user_id_x':'user_id','user_id_y':'recommended_id'}).drop_duplicates()