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

-------------------------------

-- 将上面的方法改良一下，不用not in来做
with cte as
(select
distinct a.user_id,
b.user_id as recommended_id
from Listens a
inner join Listens b on a.user_id != b.user_id and a.song_id = b.song_id and a.day = b.day
group by 1,2,a.day
having count(distinct a.song_id) >= 3)

select
distinct a.user_id, recommended_id
from cte a
left join Friendship b on (a.user_id = b.user1_id and a.recommended_id = b.user2_id) or (a.user_id = b.user2_id and a.recommended_id = b.user1_id)
where b.user1_id is null

-------------------------------

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

-------------------------------

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

-------------------------------

-- Python
import pandas as pd

def recommend_friends(listens: pd.DataFrame, friendship: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(listens,listens, on = ['song_id','day'])
    merge = merge.query("user_id_x < user_id_y") 
    -- 这里我们限定了大小，因为python还是不如sql那样，在做join的时候用or
    -- 也是因为这里我们限定了大小，在最后结果我们需要将其颠倒得到另一个结果

    candidates = merge.groupby(['user_id_x','user_id_y','day'],as_index = False).song_id.nunique()
    candidates = candidates.query("song_id >= 3")[['user_id_x','user_id_y']].drop_duplicates()


    filter_out1 = pd.merge(candidates,friendship, left_on = ['user_id_x','user_id_y'],right_on = ['user1_id','user2_id'], how = 'left')
    filter_out1 = filter_out1.query("user1_id.isna()").rename(columns = {'user_id_x':'user_id','user_id_y':'recommended_id'})
    res = pd.concat([filter_out1[['user_id','recommended_id']],filter_out1[['recommended_id','user_id']].rename(columns = {'recommended_id':'user_id','user_id':'recommended_id'})])
    return res


-- 另外的做法
import pandas as pd

def recommend_friends(listens: pd.DataFrame, friendship: pd.DataFrame) -> pd.DataFrame:
    friend1 = friendship[['user1_id','user2_id']].rename(columns = {'user1_id':'user_id','user2_id':'friend'})
    friend2 = friendship[['user2_id','user1_id']].rename(columns = {'user2_id':'user_id','user1_id':'friend'})
    friend = pd.concat([friend1,friend2]).drop_duplicates()

    song = pd.merge(listens,listens,on = ['song_id','day'])
    song = song[song['user_id_x'] != song['user_id_y']]
    song = song.groupby(['user_id_x','user_id_y','day'],as_index = False).song_id.nunique()
    song = song[song['song_id'] >= 3]
    potential_friend = song[['user_id_x','user_id_y']].drop_duplicates()

    res = pd.merge(potential_friend,friend, left_on = ['user_id_x','user_id_y'], right_on = ['user_id','friend'], how = 'left')
    res = res[res['user_id'].isna()]
    return res[['user_id_x','user_id_y']].rename(columns = {'user_id_x':'user_id','user_id_y':'recommended_id'})