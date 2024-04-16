select
b.age_bucket,
ifnull(round(100* sum(case when activity_type = 'send' then time_spent end)/sum(time_spent),2),0) as send_perc,
ifnull(round(100* sum(case when activity_type = 'open' then time_spent end)/sum(time_spent),2),0) as open_perc
from Activities a
left join Age b on a.user_id = b.user_id
group by 1