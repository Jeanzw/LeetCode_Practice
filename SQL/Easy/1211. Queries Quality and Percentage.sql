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