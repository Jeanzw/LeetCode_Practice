/*
1.我们首先把每一个player的install_date给求出来
select player_id,min(event_date) as install_date from Activity
group by player_id

2.而后再将其与原表联合起来，来看看哪些是有第二天就继续上线的记录的
select * from
(select player_id,min(event_date) as install_date from Activity
group by player_id) a
left join Activity b
on a.player_id = b.player_id 
and a.install_date + 1 = b.event_date
我们会发现如果第二天不存在，那么在第二个date列会显示null
到目前为止，我们的总表就已经搞定了，接下来我们就要开始抽取我们想要的东西了
*/

select install_date as install_dt,
count(distinct a.player_id) as installs,
round(sum(case when b.event_date is not null then 1 else 0 end)
/
count(distinct a.player_id),2) as Day1_retention
from
(select player_id,min(event_date) as install_date from Activity
group by player_id) a
left join Activity b
on a.player_id = b.player_id 
and a.install_date + 1 = b.event_date
group by install_date

--------------------------

-- 上面这种做法可以改成：
select
a.event_date as install_dt,
count(distinct a.player_id) as installs,
round(count(distinct b.player_id)/count(distinct a.player_id),2) as Day1_retention
from Activity a
left join Activity b on a.player_id = b.player_id and datediff(b.event_date,a.event_date) = 1
where (a.player_id,a.event_date) in (select player_id,min(event_date) from Activity group by 1)
group by 1

-------------------------

-- 之后做的：
-- 直接用cte来把first_login给抽出来
-- 之后和原表相连，用playerid和day来做连接
-- 而后直接用count就好了，如果是null，那么count就会是0，不必担心会把它们计算进去
with first_login as
(select player_id, min(event_date) as first_login from Activity group by 1)

select 
f.first_login as install_dt,
count(distinct f.player_id) as installs,
round(count(event_date)/count(first_login),2) as Day1_retention
from first_login f
left join Activity a on f.player_id = a.player_id 
and datediff(a.event_date,f.first_login) =  1
group by 1

--------------------------

-- 我这一次做的时候，觉得上面用count(event_date)来计算Day1_retention其实不太好。
-- 因为现实可能是，player用不同的device在某一天上线了两次，那么如果用date来作为计量其实会有重复
-- 所以最准确的还是用playerid作为计量依据
with first_day as
(select 
    player_id,
    min(event_date) as install_dt
    from Activity
    group by 1)
    
select
    install_dt,
    count(distinct f.player_id) as installs,
    round(count(distinct a.player_id)/count(distinct f.player_id),2) as Day1_retention
    from first_day f
    left join Activity a on f.player_id = a.player_id and datediff(a.event_date,f.install_dt) = 1
    group by 1

--------------------------

-- Python
import pandas as pd
import numpy as np

def gameplay_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    install_dt = activity.groupby(['player_id'],as_index = False).event_date.min()
    merge = pd.merge(install_dt,activity,on = 'player_id')
    merge['second_login'] = np.where((merge['event_date_y'] - merge['event_date_x']).dt.days == 1, merge['player_id'],None)
    merge = merge.groupby(['event_date_x'], as_index = False).agg(
        n = ('second_login','nunique'),
        installs = ('player_id','nunique')
    )
    merge['Day1_retention'] = round(merge['n']/merge['installs'] + 1e-9,2)
    return merge[['event_date_x','installs','Day1_retention']].rename(columns = {'event_date_x':'install_dt'})