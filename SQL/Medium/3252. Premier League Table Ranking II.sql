-- 这道题题目数据集有问题
with cte as
(select
team_id,
team_name,
sum(wins * 3 + draws) as points,
rank() over (order by sum(wins * 3 + draws) desc) as position,
round(percent_rank() over (order by sum(wins * 3 + draws) desc),2) as pct_rnk
from TeamStats
group by 1,2)

select 
    team_name,
    points,
    position,
    -- pct_rnk,
    case when pct_rnk <= 0.33 then 'Tier 1'
         when pct_rnk >= 0.66 then 'Tier 3'
         else 'Tier 2' end as tier
from cte
order by 2 desc, 1



-- Python
import pandas as pd
import numpy as np

def calculate_team_tiers(team_stats: pd.DataFrame) -> pd.DataFrame:
    team_stats['points'] = team_stats['wins'] * 3 + team_stats['draws']
    team_stats['position'] = team_stats.points.rank(method = 'min', ascending = False)
    team_stats.sort_values('points', ascending = False,inplace = True)
    
    team_stats['tier'] = np.where(team_stats.position <= team_stats.position.quantile(.33),'Tier 1',
                         np.where(team_stats.position <= team_stats.position.quantile(.66),'Tier 2','Tier 3'))
    return team_stats