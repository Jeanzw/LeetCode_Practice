with cte as
(select
city,
hour(call_time) as calling_hour,
count(*) as call_num,
dense_rank() over (partition by city order by count(*) desc) as rnk
from Calls
group by 1,2)

select city, calling_hour as peak_calling_hour,call_num  as number_of_calls
from cte
where rnk = 1
order by 2 desc, 1 desc