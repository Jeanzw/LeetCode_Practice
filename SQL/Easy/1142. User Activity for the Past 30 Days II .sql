select ifnull(round(count(session_id)/count(distinct user_id),2),0) as  average_sessions_per_user from
(select user_id,session_id from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by 1,2)tmp

-- 这道题注意可能会有null的情况存在
select ifnull(round(count(distinct session_id)/count(distinct user_id),2),0.00) as average_sessions_per_user from Activity
where datediff('2019-07-27',activity_date) < 30