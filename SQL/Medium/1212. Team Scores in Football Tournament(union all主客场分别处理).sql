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