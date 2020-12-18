select 
    contest_id,
    round(100 * count(distinct r.user_id)/count(distinct u.user_id),2) as percentage 
    from Register r,Users u
group by 1
order by 2 desc, 1


-- 我其实是觉得上面这种直接两个表什么连接都没有直接抽取是很不make sense的
-- 所以相对来说，下面这种我觉得比较靠谱
SELECT contest_id
    , ROUND(COUNT(DISTINCT user_id) * 100 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM Register 
GROUP BY contest_id
    ORDER BY percentage DESC, contest_id