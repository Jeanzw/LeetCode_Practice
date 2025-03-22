# Write your MySQL query statement below
select
season_id,
team_id,
team_name,
(wins * 3  + draws) as points,
(goals_for - goals_against) as goal_difference,
row_number() over (partition by season_id order by (wins * 3  + draws) desc, (goals_for - goals_against) desc, team_name) as position
from SeasonStats
order by 1,6,3

-----------------------------------

-- Python
import pandas as pd

def process_team_standings(season_stats: pd.DataFrame) -> pd.DataFrame:
    season_stats['points'] = 3 * season_stats['wins'] + season_stats['draws']
    season_stats['goal_difference'] = season_stats['goals_for'] - season_stats['goals_against']
    season_stats.sort_values(['season_id','points','goal_difference','team_name'], ascending = [1,0,0,1], inplace = True)
    season_stats['position'] = season_stats.groupby(['season_id']).cumcount() + 1
    return season_stats[['season_id','team_id','team_name','points','goal_difference','position']]