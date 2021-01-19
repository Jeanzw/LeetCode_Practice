select min(activity_date) as login_date,count(distinct user_id) as user_count from Traffic
where (user_id,activity_date) in 
(select user_id,min(activity_date) from Traffic
where activity = 'login'  --这一个条件需要注意，我经常会忽略掉
group by user_id
having datediff('2019-06-30',MIN(activity_date))<=90)
group by activity_date

/*
由于我们要求的是最小的时间，所以一定要用where来作为指引
*/

--下面是我第二次写的答案，我们在where里面已经做了min（date）的筛选了
select activity_date as login_date, count(distinct user_id) as user_count from Traffic 
where (user_id,activity_date) in
(
select user_id, min(activity_date) as min_log from Traffic
    where activity = 'login'
group by 1
    having min_log  >= '2019-04-01'
)
group by 1

-- 下面是新做的答案：
-- 我们不用In来解题，直接划定范围，然后开始计数
select first_login as login_date, count(distinct user_id) as user_count from
(select user_id,min(activity_date) as first_login from Traffic
where activity = 'login'
group by 1
having datediff('2019-06-30',min(activity_date)) <= 90)tmp
group by 1