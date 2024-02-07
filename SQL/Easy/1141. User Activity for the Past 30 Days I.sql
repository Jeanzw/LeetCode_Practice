select activity_date as day, count(distinct user_id) as active_users from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date


-- 另外的做法：用datediff
select 
    activity_date as day,
    count(distinct user_id) as active_users
    from Activity 
where datediff('2019-07-27',activity_date) between 0 and 29
-- 我们一定要是有0的存在，不然就可能存在activity_date在2019-07-27之后的情况了
group by 1