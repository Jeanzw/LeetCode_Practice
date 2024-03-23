select a.team_name as home_team, b.team_name as away_team
from Teams a, Teams b
where a.team_name != b.team_name