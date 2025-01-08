# Write your MySQL query statement below
select
b.team_name,
case when time_stamp <= '45:00' then 1 else 2 end as half_number,
-- 这里timestamp可以直接进行对比
sum(case when b.team_name = c.team_name then 1 else -1 end) as dominance
from Passes a
left join Teams b on a.pass_from = b.player_id 
left join Teams c on a.pass_to = c.player_id
group by 1,2
order by 1,2


-- Python
import pandas as pd
import numpy as np

def calculate_team_dominance(teams: pd.DataFrame, passes: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(passes, teams, left_on = 'pass_from', right_on = 'player_id', how = 'left').merge(teams, left_on = 'pass_to', right_on = 'player_id', how = 'left')
    merge['half_number'] = np.where(merge['time_stamp'] <= '45:00', 1, 2)
    merge['dominance'] = np.where(merge['team_name_x'] == merge['team_name_y'], 1, -1)
    
    res = merge.groupby(['team_name_x','half_number'],as_index = False).dominance.sum()
    return res.rename(columns = {'team_name_x':'team_name'}).sort_values(['team_name','half_number'])