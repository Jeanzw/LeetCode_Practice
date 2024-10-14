select query_name,
round(avg(rating/position),2) as quality,
round(100 * sum(case when rating< 3 then 1 else 0 end)/count(*),2) as poor_query_percentage
from Queries
group by 1
---------------上面的query已经不能过了---------------------

-- 我觉得这道题简直奇葩……
-- 1. 这个query_name中可能存在null，我们是要把这部分给剔除的
-- 2. 题目中说了有duplicate row，但是我们不在意，直接求解？？？
select
query_name,
round(avg(rating/position),2) as quality,
round(100* count(case when rating < 3 then result end)
/count(*),2) as poor_query_percentage
from Queries
where query_name is not null
group by 1


-- 关于求poor_query_percentage还有一个思路
select
    query_name,
    round(avg(rating/position),2) as quality,
    -- 我们赋值，如果符合条件就给1，不符合条件就给0，然后求均值
    round(100* avg(case when rating < 3 then 1 else 0 end),2) as poor_query_percentage
from Queries
where query_name is not null
group by 1


-- python
import pandas as pd

def queries_stats(queries: pd.DataFrame) -> pd.DataFrame:
    queries['quality_avg'] = queries['rating']/queries['position'] + 1e-6
    # 下面求poor_query_percentage的逻辑有点意思，也可以用在sql里面
    # 就是我们直接赋值，当符合条件就给1，不符合条件的就给0，然后求均值
    # 这里的1是直接判断queries['rating'] < 3这个条件是否成立，因为是二位，符合就是1，不符合就是0
    queries['poor_query_percentage'] = (queries['rating'] < 3)*100
    queries = queries.groupby(['query_name'],as_index = False).agg(
        quality = ('quality_avg', 'mean'),
        poor_query_percentage = ('poor_query_percentage','mean')
    )
    queries['quality'] = (q