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