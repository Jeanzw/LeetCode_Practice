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

def longest_winning_streak(matches: pd.DataFrame) -> pd.DataFrame:
    matches['rnk1'] = matches.groupby(['player_id']).match_day.rank()
    matches['rnk2'] = matches.groupby(['player_id','result']).match_day.rank()
    matches['bridge'] = matches['rnk1'] - matches['rnk2']

    win = matches[matches['result'] == 'Win']
    win = win.groupby(['player_id','bridge'],as_index = False).match_day.nunique()

    merge = pd.merge(matches,win,on = 'player_id', how = 'left')
    merge = merge.groupby(['player_id'],as_index = False).match_day_y.max().fillna(0)

    return merge.rename(columns = {'match_day_y':'longest_streak'})