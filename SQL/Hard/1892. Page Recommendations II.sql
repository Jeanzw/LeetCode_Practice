-- 我是用这种方法做的，但是存在问题是超时，因为用了一个not in，这个其实是不太高效的方式的
with friend as
(select id,friend_id from
(select user1_id as id,user2_id as friend_id from Friendship
union all  --我们这里可以将union all换成union，那么就可以避免重复的情况了
select user2_id as id,user1_id as friend_id from Friendship
)tmp
group by 1,2)

select
    f.id as user_id,
    l.page_id,
    count(distinct l.user_id) as friends_likes
    from friend f
    join Likes l on f.friend_id = l.user_id
    where (f.id,l.page_id) not in (select user_id,page_id from Likes)
    group by 1,2
    order by 1
    

-- 不会超时的方法就是再用一个left join
-- 也是在这里我才知道left join其实是比not in要高效的
with friend as
(select id,friend_id from
(select user1_id as id,user2_id as friend_id from Friendship
union
select user2_id as id,user1_id as friend_id from Friendship
)tmp
group by 1,2)

select
    f.id as user_id,
    l.page_id,
    count(distinct l.user_id) as friends_likes
    from friend f
    left join Likes l on f.friend_id = l.user_id
    left join likes l2 on f.id=l2.user_id and l.page_id=l2.page_id
-------------------------------------------------
-- 我们这里是需要先让friend join上，然后再保证user_id是可以match上的
-- 不然的话，如果我们先保证user_id是可以match上，再让friend join上那么是不能用null值给处理掉不符合规则的行数
-------------------------------------------------


    --我们l2出来的数肯定就是userid和对应喜欢过的page
    -- 那么如果page id可以连得上就说明喜欢的page和朋友喜欢的page是对得上的，那么其实就不应该列在我们的推荐系统中了
    where l2.page_id is null
    group by 1,2
    order by 1



-- Python
import pandas as pd

def recommend_page(friendship: pd.DataFrame, likes: pd.DataFrame) -> pd.DataFrame:
    user1 = friendship.rename(columns = {'user1_id':'user_id','user2_id':'friend'})
    user2 = friendship.rename(columns = {'user2_id':'user_id','user1_id':'friend'})
    user = pd.concat([user1,user2]).drop_duplicates()

    merge = pd.merge(user,likes, left_on = 'friend', right_on = 'user_id', how = 'left').rename(columns = {'user_id_x':'user_id'})
    
    merge = pd.merge(merge,likes, on = ['user_id','page_id'],how = 'left',indicator = True)
    merge = merge.query("_merge == 'left_only'")

    return merge.groupby(['user_id','page_id'],as_index = False).user_id_y.nunique().rename(columns = {'user_id_y':'friends_likes'})