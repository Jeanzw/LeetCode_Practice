SELECT ROUND(AVG(cnt), 2) AS average_daily_percent FROM
(
    SELECT (COUNT(DISTINCT r.post_id)/ COUNT(DISTINCT a.post_id))*100  AS cnt
FROM Actions a
LEFT JOIN Removals r
ON a.post_id = r.post_id
WHERE extra='spam' and action = 'report'
GROUP BY action_date)tmp


-- 下面是容易错的点：
-- 1. Actions这张表的post_id在被移走之前可能会反复出现，所以直接来计算个数是会有dummy的存在的
-- 2. 对于Removal这张表是不存在重复的情况的，所以可以直接用
select round(avg(percentage),2) as average_daily_percent
from 
(select 
action_date,
100*sum(case when r.post_id is not null then 1 else 0 end)
/
count(distinct a.post_id) as percentage
from Actions a left join Removals r on a.post_id = r.post_id
where extra = 'spam' and action = 'report'
group by 1)tmp


-- 更加清楚就是用cte
with spam as
(select post_id, action_date from Actions 
where action = 'report' and extra = 'spam'
group by 1,2)
, daily_remove as
(select 
a.action_date,
count(distinct b.post_id)/count(distinct a.post_id) as remove_rate
from spam a
left join Removals b on a.post_id = b.post_id
group by 1)

select round(100 * avg(remove_rate),2) as average_daily_percent from daily_remove


-- Python
import pandas as pd
import numpy as np

def reported_posts(actions: pd.DataFrame, removals: pd.DataFrame) -> pd.DataFrame:
    actions = actions.query("action == 'report' and extra == 'spam'").drop_duplicates(['action_date', 'post_id'])
    merge = pd.merge(actions,removals,on = 'post_id', how = 'left')
    merge = merge.groupby(['action_date'],as_index = False).agg(
        n = ('remove_date','count'),
        d = ('post_id','nunique')
    )
    merge['pct'] = merge['n']/merge['d']
    average_daily_percent = (100 * merge['pct'].mean()).round(2)
    return pd.DataFrame({'average_daily_percent':[average_daily_percent]})