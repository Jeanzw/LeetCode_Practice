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
    # 把host给抽出来
    team1 = matches[['host_team','host_goals','guest_goals']].rename(columns = {'host_team':'team'})
    # 把guest给抽出来
    team2 = matches[['guest_team','host_goals','guest_goals']].rename(columns = {'guest_team':'team'})

    # where语句判断每个队应该得分的情况
    team1['score'] = np.where(
        team1['host_goals']>team1['guest_goals'],3, 
        np.where(team1['host_goals']==team1['guest_goals'],1,0)
        )
    team2['score'] = np.where(
        team1['host_goals']>team1['guest_goals'],0, 
        np.where(team1['host_goals']==team1['guest_goals'],1,3)
        )
    
    # 将两张表直接合并并且求和
    team1_team2 = pd.concat([team1,team2]).groupby(['team'], as_index = False).score.sum().reset_index()
    
    # 将得分情况的表和原来队伍信息的表相连
    res = pd.merge(teams,team1_team2, left_on = 'team_id', right_on = 'team', how = 'left').fillna(0)
    # 最后取出想要的列，并且确定好排序情况
    return res[['team_id','team_name','score']].rename(columns = {'score':'num_points'}).sort_values(['num_points','team_id'], ascending = [False, True])