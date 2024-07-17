-- 下面是我最开始的方法，因为我不知道怎么实现 如果只有一条内容就抽取这一条
-- 于是我才用了union的方法，将这两种情况分开讨论
-- 如果只有一条数据那么它就自己走
-- 如果不是，那么就用rank进行排序
select username, activity , startDate , endDate  from
(select *,rank() over (partition by username order by startDate desc) as rnk from UserActivity)tmo
where rnk = 2

union

select * from UserActivity
where username in
(select username from UserActivity
group by username
having count(*) = 1)



-- 但其实可以这样做的
-- 也就是说给每个user两个指标，用window function来计算
-- 其中一个指标是算在各自user内部这个activity是第几名
-- 第二个指标就是计算这个users总共有多少个activity
-- 而后我们只需要确保，要不然排名是第2，如果这个user只有一个activity，那么就确保计算的数为1
select username, activity, startDate, endDate from (
select
    username,
    activity,
    startDate,
    endDate,
    row_number() over (partition by username order by startDate desc) as ranks,
    count(username) over (partition by username) as counts
from UserActivity) as t
where counts = 1 or ranks = 2;


-- 并且如果不用MS SQL，也可以考虑这样做
SELECT * 
FROM UserActivity 
GROUP BY username 
HAVING COUNT(*) = 1

UNION ALL

SELECT u1.*
FROM UserActivity u1 
LEFT JOIN UserActivity u2 
    ON u1.username = u2.username AND u1.endDate < u2.endDate
GROUP BY u1.username, u1.endDate
HAVING COUNT(u2.endDate) = 1



-- Python
import pandas as pd

def second_most_recent(user_activity: pd.DataFrame) -> pd.DataFrame:
    summary = user_activity.sort_values(['username','startDate'], ascending = [True, False])
    rnk = summary.groupby(['username']).head(2).groupby(['username']).tail(1)
    return rnk