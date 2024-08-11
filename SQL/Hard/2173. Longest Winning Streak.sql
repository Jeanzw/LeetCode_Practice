-- 这道题的难点在于day其实可以不连续，那么我们就找不到对应的bridge
-- 如果原来的表没有bridge那么我们就给他造一个bridge即可
-- 也就是说我用两个rank window，前者只针对player_id，后者针对player_id和result
with player_rnk as
(select player_id, match_day, result, 
rank() over (partition by player_id order by match_day) as rnk,
rank() over (partition by player_id,result order by match_day) as rnk_2
from Matches
order by 1,2
)
, duration as
(select player_id, count(distinct match_day) as duration
from player_rnk
where result = 'Win'
group by player_id, rnk - rnk_2)

, framework as
(select distinct player_id from Matches)

select
a.player_id,
ifnull(max(duration),0) as longest_streak
from framework a
left join duration b on a.player_id = b.player_id
group by 1


------------- frame cte 下面完全可以直接写
select
a.player_id,
ifnull(max(duration),0) as longest_streak
from Matches a --直接拿原表
left join duration b on a.player_id = b.player_id
group by 1



-- Python
import pandas as pd
import numpy as np

def longest_winning_streak(matches: pd.DataFrame) -> pd.DataFrame:
    matches = matches.sort_values(['player_id','match_day'])
    matches['not_win'] = np.where(matches['result'] == 'Win',0,1)
    matches['group_id'] = matches.groupby(['player_id']).not_win.cumsum()

    df = matches.groupby(['player_id','group_id'], as_index = False).agg(
        streak = ('result',lambda x: (x == "Win").sum())
    )
    df = df.groupby(['player_id'],as_index = False).streak.max()
    return df.rename(columns = {'streak':'longest_streak'})