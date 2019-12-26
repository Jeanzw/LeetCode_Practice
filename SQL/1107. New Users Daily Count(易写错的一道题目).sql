select min(activity_date) as login_date,count(distinct user_id) as user_count from Traffic
where (user_id,activity_date) in 
(select user_id,min(activity_date) from Traffic
where activity = 'login'
group by user_id
having datediff('2019-06-30',MIN(activity_date))<=90)
group by activity_date

/*
由于我们要求的是最小的时间，所以一定要用where来作为指引
*/