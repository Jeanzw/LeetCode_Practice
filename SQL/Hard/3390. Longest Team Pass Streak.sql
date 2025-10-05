# Write your MySQL query statement below
with cte as
(select
a.pass_from,
a.time_stamp,
a.pass_to,
b.team_name,
b.team_name as from_team,
c.team_name as to_team,
-- case when b.team_name = c.team_name then 0 else 1 end as break_flg, -- 其实这一行要不要不影响结果，我们的bridge是下面的group_id
SUM(case when b.team_name = c.team_name then 0 else 1 end) OVER (PARTITION BY b.team_name ORDER BY time_stamp) AS group_id
from Passes a
left join Teams b on a.pass_from = b.player_id
left join Teams c on a.pass_to = c.player_id
order by time_stamp)
, summary as --这一步其实已经处理完了
(select
team_name,
group_id,
count(*) as cnt
from cte
group by 1,2)

select team_name, 
max(case when group_id = 0 then cnt else cnt - 1 end) as longest_streak 
-- 当bridge发生变动的时候，那一行其实是不能要的，比如说：
-- | 4         | 00:10      | 5       | Arsenal   | Chelsea   | 1   | 1      |
-- | 1         | 00:25      | 2       | Arsenal   | Arsenal   | 0   | 1      |
-- | 2         | 00:27      | 3       | Arsenal   | Arsenal   | 0   | 1      |
-- 我们其实只认为Arsenal有两行而不是三行
from summary
group by 1
having longest_streak > 0
order by 1

-- 对上面的query进行修改：
with cte as
(select
b.team_name as pass_from,
c.team_name as pass_to,time_stamp
, sum(case when b.team_name = c.team_name then 0 else 1 end) over (partition by b.team_name order by a.time_stamp) as flg
from Passes a
left join Teams b on a.pass_from = b.player_id 
left join Teams c on a.pass_to = c.player_id)
, summary as
(select
pass_from as team_name,
flg,
count(*) as longest_streak
from cte
where pass_from = pass_to
-- 当bridge发生变动的时候，那一行其实是不能要的，所以我们这里加个where来确定这种情况
group by 1,2)

select team_name, max(longest_streak) as longest_streak from summary group by 1
order by 1

-----------------------

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


-------------------
-- 另外的做法
import pandas as pd
import numpy as np

def calculate_longest_streaks(teams: pd.DataFrame, passes: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(passes,teams,left_on = 'pass_from',right_on = 'player_id').merge(teams,left_on = 'pass_to',right_on = 'player_id')
    merge['break_flg'] = np.where(merge['team_name_x'] == merge['team_name_y'], 0, 1)
    merge['bridge'] = merge.groupby(['team_name_x']).break_flg.cumsum()
    
    merge = merge.groupby(['bridge','team_name_x'], as_index = False).size()
    merge['size'] = np.where(merge['bridge'] == 0, merge['size'], merge['size'] - 1)
    merge.sort_values(['team_name_x','size'], ascending = [1,0], inplace = True)
    merge = merge.groupby(['team_name_x']).head(1)
    return merge[merge['size'] > 0][['team_name_x','size']].rename(columns = {'team_name_x':'team_name','size':'longest_streak'})


-- 另外的做法
import pandas as pd
import numpy as np

def calculate_longest_streaks(teams: pd.DataFrame, passes: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(passes, teams, left_on = 'pass_from', right_on = 'player_id').merge(teams, left_on = 'pass_to', right_on = 'player_id')
    merge['flg'] = np.where(merge['team_name_x'] == merge['team_name_y'], 0, 1)
    merge.sort_values(['team_name_x','time_stamp'], inplace = True)
    merge['flg'] = merge.groupby(['team_name_x']).flg.cumsum()
    merge = merge[merge['team_name_x'] == merge['team_name_y']]
    merge = merge.groupby(['team_name_x','flg'],as_index = False).size()
    merge.sort_values(['team_name_x','size'], ascending = [1,0], inplace = True)
    merge = merge.groupby(['team_name_x']).head(1)
    return merge[['team_name_x','size']].rename(columns = {'team_name_x':'team_name','size':'longest_streak'})