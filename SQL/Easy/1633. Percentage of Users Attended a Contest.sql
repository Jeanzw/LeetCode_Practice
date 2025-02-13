select 
    contest_id,
    round(100 * count(distinct r.user_id)/count(distinct u.user_id),2) as percentage 
    from Register r,Users u
group by 1
order by 2 desc, 1

----------------------------------

-- 我其实是觉得上面这种直接两个表什么连接都没有直接抽取是很不make sense的
-- 所以相对来说，下面这种我觉得比较靠谱
SELECT contest_id
    , ROUND(COUNT(DISTINCT user_id) * 100 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM Register 
GROUP BY contest_id
    ORDER BY percentage DESC, contest_id

----------------------------------

-- 我觉得更严谨的做法其实是要对register这张表进行一个筛选
-- 因为我们不能保证register这张表里面只存在users表里面的users
select 
contest_id,
round(100 * count(distinct user_id)/(select count(distinct user_id) from Users),2) as percentage

from Register 
where user_id in (select user_id from Users)
group by 1
order by 2 desc,1

----------------------------------

-- 筛选也可以用join
select 
contest_id,
round(100 * count(distinct b.user_id)/(select count(distinct user_id) from Users),2) as percentage
from Users a
inner join Register b on a.user_id = b.user_id
group by 1
order by 2 desc, 1

----------------------------------

-- Python
import pandas as pd

def users_percentage(users: pd.DataFrame, register: pd.DataFrame) -> pd.DataFrame:
    cnt_de = users.user_id.nunique()
    register = register.groupby(['contest_id'], as_index = False).user_id.nunique()
    register['percentage'] = round(100 * register['user_id']/cnt_de,2)
    return register[['contest_id','percentage']].sort_values(['percentage','contest_id'], ascending = [0,1])