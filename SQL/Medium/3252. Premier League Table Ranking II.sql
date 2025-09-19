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

-- 这道题之所以不能用percent_rank是因为它和题目要的“按队伍个数 33%/33%/34% 分桶（且边界并列归上层）”并不等价
-- 1.公式不同步
-- PERCENT_RANK = (RANK - 1) / (N - 1)（N 为总队数）。
-- 你用阈值 0.33 / 0.66，等价于：

-- Tier1：RANK ≤ (N-1)/3 + 1

-- Tier3：RANK ≥ 2*(N-1)/3 + 1
-- 而题目按队伍个数三等分应是：

-- Tier1：RANK ≤ floor(N/3)（边界并列往上并入 Tier1）

-- Tier3：RANK ≥ floor(2N/3)+1
-- 2.并列与跳位：
-- PERCENT_RANK()基于 RANK()，遇到并列会跳位，这本身与“并列归上层”的精神还算一致，但配合上面问题，会进一步放大误差，尤其是小样本时很明显。

with cte as
(select
team_name,
wins * 3 + draws as points,
rank() over (order by wins * 3 + draws desc) as position,
count(*) over () as cnt
from TeamStats)

select
team_name,
points,
position,
case when position < cnt/3 + 1 then 'Tier 1'
     when position < 2 * cnt/3 + 1 then 'Tier 2'
     else 'Tier 3' end as tier
from cte
order by 2 desc, 1

---------------------------------------

-- Python,这个和sql的第一种解法一样存在问题
import pandas as pd
import numpy as np

def calculate_team_tiers(team_stats: pd.DataFrame) -> pd.DataFrame:
    team_stats['points'] = team_stats['wins'] * 3 + team_stats['draws']
    team_stats['position'] = team_stats.points.rank(method = 'min', ascending = False)
    team_stats.sort_values('points', ascending = False,inplace = True)
    
    team_stats['tier'] = np.where(team_stats.position <= team_stats.position.quantile(.33),'Tier 1',
                         np.where(team_stats.position <= team_stats.position.quantile(.66),'Tier 2','Tier 3'))
    return team_stats

-- 所以按照sql的写法我们改成如下内容，就可以过了

import pandas as pd
import numpy as np

def calculate_team_tiers(team_stats: pd.DataFrame) -> pd.DataFrame:
    team_stats['points'] = team_stats['wins'] * 3 + team_stats['draws']
    team_stats['position'] = team_stats.points.rank(method = 'min', ascending = False)
    team_stats['cnt'] = team_stats.team_id.nunique()
    
    team_stats['tier'] = np.where(team_stats.position < team_stats.cnt/3 + 1,'Tier 1',
                         np.where(team_stats.position < 2 * team_stats.cnt/3 + 1,'Tier 2','Tier 3'))
    return team_stats[['team_name','points','position','tier']].sort_values(['points','team_name'], ascending = [0,1])