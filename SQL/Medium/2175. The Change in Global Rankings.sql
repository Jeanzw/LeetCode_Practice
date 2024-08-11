-- cast的用法：https://www.w3schools.com/mysql/func_mysql_cast.asp

with before_rank as
(select team_id, name, points, row_number() over (order by points desc, name) as ori_rnk from TeamPoints)
, after_rank as
(select
a.*, a.points + b.points_change as after_points,
row_number() over (order by a.points + b.points_change desc, name) as after_rnk
from before_rank a
left join PointsChange b on a.team_id = b.team_id
)

select 
team_id, name, cast(ori_rnk AS SIGNED) - cast(after_rnk AS SIGNED) as rank_diff
-- 这里用cast的原因：
-- Because we want to calculate diff, which should be signed.
-- However, ROW_NUMBER() returns an unsigned value.
from after_rank
order by ori_rnk



-- Python
import pandas as pd

def global_ratings_change(team_points: pd.DataFrame, points_change: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(team_points,points_change, on = 'team_id', how = 'left')
    merge['after_point'] = merge['points'] + merge['points_change']
    merge = merge.sort_values(['points','name'], ascending = [0,1])
    merge['before_rank'] = merge.points.rank(method = 'first', ascending = False)
    merge = merge.sort_values(['after_point','name'], ascending = [0,1])
    merge['after_rank'] = merge.after_point.rank(method = 'first', ascending = False)

    merge['rank_diff'] = merge['before_rank'] - merge['after_rank']
    return merge[['team_id','name','rank_diff']]