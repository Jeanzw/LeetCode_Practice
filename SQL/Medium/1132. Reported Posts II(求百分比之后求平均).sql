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