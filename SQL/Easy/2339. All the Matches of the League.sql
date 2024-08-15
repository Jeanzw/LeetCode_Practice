select a.team_name as home_team, b.team_name as away_team
from Teams a, Teams b
where a.team_name != b.team_name


-- Python
import pandas as pd

def find_all_matches(teams: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(teams,teams,how = 'cross')
    merge = merge.query("team_name_x != team_name_y")
    return merge.rename(columns = {'team_name_x':'home_team','team_name_y':'away_team'})