select ifnull(round(count(session_id)/count(distinct user_id),2),0) as  average_sessions_per_user from
(select user_id,session_id from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by 1,2)tmp