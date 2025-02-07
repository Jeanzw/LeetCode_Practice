select name,ifnull(sum(distance),0) as travelled_distance from Users a
left join Rides b on a.id = b.user_id
group by 1
order by 2 desc,1

-----------------------------

-- 现在上面的方式已经不能用了，因为可能存在两个同名的情况
with summary as
(select
a.id,
a.name,
ifnull(sum(distance),0) as travelled_distance
from Users a
left join Rides b on a.id = b.user_id
group by 1,2
order by 3 desc, 2)

select name,travelled_distance from summary

-----------------------------

-- 直接group by就用a.id即可
select
a.name,
ifnull(sum(distance),0) as travelled_distance
from Users a
left join Rides b on a.id = b.user_id
group by a.id
order by 2 desc, 1

-----------------------------

-- Python
import pandas as pd

def top_travellers(users: pd.DataFrame, rides: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(users,rides,left_on = 'id', right_on = 'user_id', how = 'left').fillna(0)
    merge = merge.groupby(['id_x','name'],as_index = False).distance.sum()
    return merge[['name','distance']].rename(columns = {'distance':'travelled_distance'}).sort_values(['travelled_distance','name'], ascending = [0,1])