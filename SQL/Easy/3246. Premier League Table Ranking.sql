select
team_id,
team_name,
sum(wins * 3 + draws * 1) as points,
rank() over (order by sum(wins * 3 + draws * 1) desc) as position
from TeamStats
group by 1,2
order by 3 desc, 2

--------------------------

-- Python
import pandas as pd

def calculate_team_standings(team_stats: pd.DataFrame) -> pd.DataFrame:
    team_stats['points'] = team_stats['wins'] * 3 + team_stats['draws']
    team_stats['position'] = team_stats.points.rank(method = 'min',ascending = False)
    return team_stats[['team_id','team_name','points','position']].sort_values(['points','team_name'], ascending = [0,1])