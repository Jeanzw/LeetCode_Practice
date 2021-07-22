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