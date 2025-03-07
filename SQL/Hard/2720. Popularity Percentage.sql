with summary as
(select user1 as user, user2 as friend from Friends
union
select user2 as user, user1 as friend from Friends
)
, total as
(select count(distinct user) as tt from summary)

select 
user as user1, round(100 * count(distinct friend)/(select tt from total),2) as percentage_popularity
from summary
group by 1
order by 1

-----------------------

-- 也可以用window function来做
with summary as
(select user1 as user, user2 as friend from Friends
union
select user2 as user, user1 as friend from Friends
)
select 
user as user1, round(100 * count(distinct friend)/count(user) over (),2) as percentage_popularity
from summary
group by 1
order by 1

-----------------------

-- Python
import pandas as pd

def popularity_percentage(friends: pd.DataFrame) -> pd.DataFrame:
    friends1 = friends.rename(columns = {'user1':'user1','user2':'friend'})
    friends2 = friends[['user2','user1']].rename(columns = {'user2':'user1','user1':'friend'})
    concat = pd.concat([friends1, friends2]).drop_duplicates()
    friend = concat.groupby(['user1'], as_index = False).friend.nunique()
    friend['tt'] = friend.user1.nunique()
    friend['percentage_popularity'] = round(100 * friend['friend']/friend['tt'],2)

    return friend[['user1','percentage_popularity']].sort_values('user1')