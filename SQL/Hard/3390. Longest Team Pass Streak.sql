# Write your MySQL query statement below
# Write your MySQL query statement below
with cte as
(select
a.pass_from,
a.time_stamp,
a.pass_to,
b.team_name,
b.team_name as from_team,
c.team_name as to_team,
case when b.team_name = c.team_name then 0 else 1 end as break_flg,
SUM(case when b.team_name = c.team_name then 0 else 1 end) OVER (PARTITION BY b.team_name ORDER BY time_stamp) AS group_id
from Passes a
left join Teams b on a.pass_from = b.player_id
left join Teams c on a.pass_to = c.player_id
order by time_stamp)
, summary as
(select
team_name,
group_id,
count(*) as cnt
from cte
group by 1,2)

select team_name, max(case when group_id = 0 then cnt else cnt - 1 end) as longest_streak
from summary
group by 1
having longest_streak > 0
order by 1



-- Python
import pandas as pd
import numpy as np

def calculate_longest_streaks(teams: pd.DataFrame, passes: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(passes,teams,left_on = 'pass_from', right_on = 'player_id', how = 'left').merge(teams,left_on = 'pass_to', right_on = 'player_id', how = 'left')
    merge['break_flg'] = np.where(merge['team_name_x'] == merge['team_name_y'], 0, 1)
    merge.sort_values(['team_name_x','time_stamp'], inplace = True)
    merge['cum_sum'] = merge.groupby(['team_name_x']).break_flg.cumsum()

    merge = merge.groupby(['team_name_x','cum_sum'], as_index = False).size()
    merge['streak'] = np.where(merge['cum_sum'] == 0, merge['size'], merge['size'] - 1)
    merge = merge.groupby(['team_name_x'],as_index = False).streak.max()
    return merge[merge['streak'] > 0].rename(columns = {'team_name_x':'team_name','streak':'longest_streak'}).sort_values(['team_name'])