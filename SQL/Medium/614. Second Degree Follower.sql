select a.follower,count(distinct b.follower) as num from follow as a
left join follow as b on a.follower = b.followee
where b.follower is not null
group by b.followee

---------------------

/*也可以不用left join，而直接用join求交集
但是无论如何，有一点容易错的地方就是count里面一定是distinct b.follower
这个才是每个followee真正的follower个数，不然就会出现重复的情况导致出错*/
select a.follower,count(distinct b.follower) as num 
from follow a 
join follow b
on a.follower = b.followee
group by b.followee
order by b.followee

---------------------

-- 其实这一道题目根本不需要join就可以做出来，首先我们要找出follower里面存在follower的
-- 那么我们直接在followee里面找就好了，只要我们确保其在follower里面
select followee as follower,count(distinct follower) as num from follow
where followee in (select follower from follow)
group by 1

---------------------

-- Python
import pandas as pd

def second_degree_follower(follow: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(follow,follow,left_on = 'followee',right_on = 'follower')
    merge = merge.groupby(['followee_x'],as_index = False).follower_x.nunique()
    return merge.rename(columns = {'followee_x':'follower','follower_x':'num'}).sort_values('follower')