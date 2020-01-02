select min(log_id) as start_id,max(log_id) as end_id from 
(select *,row_number() over (order by log_id) as num from Logs)a
group by log_id - num