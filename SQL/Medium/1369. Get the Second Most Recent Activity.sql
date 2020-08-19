-- 下面是我最开始的方法，因为我不知道怎么实现 如果只有一条内容就抽取这一条
-- 于是我才用了union的方法，将这两种情况分开讨论
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