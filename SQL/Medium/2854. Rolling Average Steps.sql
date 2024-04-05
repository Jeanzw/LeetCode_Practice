select
a.user_id,
a.steps_date,
round((a.steps_count + b.steps_count + c.steps_count)/3,2) as rolling_average
from Steps a
inner join Steps b on a.user_id = b.user_id and datediff(a.steps_date,b.steps_date) = 1
inner join Steps c on b.user_id = c.user_id and datediff(b.steps_date,c.steps_date) = 1
order by 1,2