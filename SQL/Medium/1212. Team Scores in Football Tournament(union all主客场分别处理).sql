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
     --   注意了，这里的case when是不能写成
     -- when host_goals>guest_goals then 0
     --   when host_goals=guest_goals then 1
     --   else 3
     -- 因为可能存在Teams上某个球队根本就没有上，那么和Matches相连后对应的是null，如果采用上面这种写法，就算是null还是会给它赋值3
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


--  Python
import pandas as pd
import numpy as np

def team_scores(teams: pd.DataFrame, matches: pd.DataFrame) -> pd.DataFrame:
    matches['h_goal'] = np.where(matches['host_goals'] > matches['guest_goals'],3,
                        (np.where(matches['host_goals'] == matches['guest_goals'],1,0)))
    matches['g_goal'] = np.where(matches['host_goals'] > matches['guest_goals'],0,
                        (np.where(matches['host_goals'] == matches['guest_goals'],1,3)))
    host = matches[['host_team','h_goal']].rename(columns = {'host_team':'team_id','h_goal':'num_points'})
    guest = matches[['guest_team','g_goal']].rename(columns = {'guest_team':'team_id','g_goal':'num_points'})
    concat = pd.concat([host,guest])

    merge = pd.merge(teams,concat, on = 'team_id', how = 'left').fillna(0)
    merge = merge.groupby(['team_id','team_name'],as_index = False).num_points.sum()
    return merge.sort_values(['num_points','team_id'],ascending = [0,1])