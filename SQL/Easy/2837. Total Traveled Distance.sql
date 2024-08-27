select
a.user_id,
a.name,
ifnull(sum(distance),0) as 'traveled distance'
from Users a
left join Rides b on a.user_id = b.user_id
group by 1,2
order by 1


-- Python
import pandas as pd

def get_total_distance(users: pd.DataFrame, rides: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(users,rides, on = 'user_id', how = 'left').fillna(0)
    merge = merge.groupby(['user_id','name'], as_index = False).distance.sum()
    return merge.rename(columns = {'distance':'traveled distance'}).sort_values("user_id")