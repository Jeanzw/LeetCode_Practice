with match_summary as
(select 
    home_team_id as id,
    home_team_goals as goals_for,
    away_team_goals as goals_against,
    case when home_team_goals > away_team_goals then 3 
        when home_team_goals = away_team_goals then 1
        else 0 end as point
 from Matches
 
 union all
 
 select 
    away_team_id as id,
    away_team_goals as goals_for,
    home_team_goals as goals_against,  
    case when home_team_goals > away_team_goals then 0
        when home_team_goals = away_team_goals then 1
        else 3 end as point
 from Matches
)

select 
team_name,
count(*) as matches_played,
sum(point) as points,
sum(goals_for) as goal_for,
sum(goals_against) as goal_against,
sum(goals_for) - sum(goals_against) as goal_diff
from Teams t
inner join match_summary m on t.team_id = m.id
group by 1
order by 3 desc,6 desc, 1



-- 别人的做法
select team_name,
sum(case when home_team_id = team_id or away_team_id = team_id then 1 else 0 end) as matches_played,
sum(case when team_id = home_team_id and home_team_goals > away_team_goals then 3 
        when team_id = away_team_id and home_team_goals < away_team_goals then 3 
        when home_team_goals = away_team_goals then 1 else 0 end) as points,
sum(case when home_team_id = team_id then home_team_goals else away_team_goals end) as goal_for,
sum(case when home_team_id = team_id then away_team_goals else home_team_goals end) as goal_against,
sum(case when home_team_id = team_id then home_team_goals-away_team_goals else away_team_goals-home_team_goals end) as goal_diff
from matches m 
join teams t on m.home_team_id = t.team_id or m.away_team_id = t.team_id
-- 关键点就在于join的时候用的or
group by team_name
order by points desc, goal_diff desc, team_name


-- Python
import pandas as pd

def league_statistics(teams: pd.DataFrame, matches: pd.DataFrame) -> pd.DataFrame:
    # Merging the teams with matches twice for home and away
    home_matches = pd.merge(matches, teams, left_on="home_team_id", right_on="team_id")
    away_matches = pd.merge(matches, teams, left_on="away_team_id", right_on="team_id")

    # Calculating points, goals for, and goals against for home and away matches
    home_matches["points"] = home_matches.apply(
        lambda x: 3
        if x["home_team_goals"] > x["away_team_goals"]
        else (1 if x["home_team_goals"] == x["away_team_goals"] else 0),
        axis=1,
    )
    home_matches["goal_for"] = home_matches["home_team_goals"]
    home_matches["goal_against"] = home_matches["away_team_goals"]

    away_matches["points"] = away_matches.apply(
        lambda x: 3
        if x["away_team_goals"] > x["home_team_goals"]
        else (1 if x["home_team_goals"] == x["away_team_goals"] else 0),
        axis=1,
    )
    away_matches["goal_for"] = away_matches["away_team_goals"]
    away_matches["goal_against"] = away_matches["home_team_goals"]

    # Concatenating the home and away results
    total_matches = pd.concat([home_matches, away_matches])

    # Grouping by team and calculating aggregates
    result = (
        total_matches.groupby("team_name")
        .agg(
            {
                "team_id": "count",
                "points": "sum",
                "goal_for": "sum",
                "goal_against": "sum",
            }
        )
        .rename(columns={"team_id": "matches_played"})
    )

    # Calculating goal difference
    result["goal_diff"] = result["goal_for"] - result["goal_against"]

    # Sorting the result
    result = result.sort_values(
        by=["points", "goal_diff", "team_name"], ascending=[False, False, True]
    )

    return result.reset_index()
