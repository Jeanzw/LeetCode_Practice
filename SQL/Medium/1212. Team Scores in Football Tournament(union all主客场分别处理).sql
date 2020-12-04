select t.*,ifnull(num_points,0) as num_points from Teams t left join 
(
select team,sum(score) as num_points from 
( 
 (select host_team as team, 
       case 
            when host_goals>guest_goals then 3
            when host_goals=guest_goals then 1
            else 0
       end as score
    from Matches)
union all
    (select guest_team as team, 
       case 
            when guest_goals>host_goals then 3
            when guest_goals=host_goals then 1
            else 0
       end as score
    from Matches)
) m
group by team) tmp

on t.team_id = tmp.team
order by num_points desc,team_id


-- 和上面的原理是一样的，但是用cte会看起来容易理解一点
with team_score as
(select team,sum(score) as score from
(select 
host_team as team,
case when host_goals > guest_goals then 3
when host_goals = guest_goals then 1
else 0 end as score from Matches
union all
select 
guest_team as team,
case when host_goals < guest_goals then 3
when host_goals = guest_goals then 1
else 0 end as score from Matches)tmp 
group by 1)
-- 上面用一个team_score来先将所有组的分数给统计出来


select t.*,ifnull(score,0) as num_points from Teams t
left join team_score ts on t.team_id = ts.team
order by num_points desc, team_id






-- 第二次写的：
select team_id,team_name, ifnull(sum(score),0) as num_points from
Teams t
left join
(select host_team as team,
sum(case when host_goals  > guest_goals then 3 
 when host_goals  = guest_goals then 1
 else 0 end ) as score
 from Matches 
 group by 1
 
 union all
 
select guest_team as team,
sum(case when host_goals  < guest_goals then 3 
 when host_goals  = guest_goals then 1
 else 0 end ) as score
 from Matches 
 group by 1) a
 on a.team = t.team_id
 group by 1,2
 order by num_points desc, team_id