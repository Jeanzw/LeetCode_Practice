select user_id,time_stamp as last_stamp
from
(select 
    user_id,
    time_stamp,
    rank() over (partition by user_id order by time_stamp desc) as rnk
    from Logins
    where year(time_stamp) = 2020)tmp
    where rnk = 1