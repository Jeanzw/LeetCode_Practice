select min(log_id) as start_id,max(log_id) as end_id from 
(select *,row_number() over (order by log_id) as num from Logs)a
group by log_id - num

-- 其实也可以就用rank来做
select min(log_id) as start_id,max(log_id) as end_id from
(select log_id,rank() over (order by log_id) as rnk from Logs)tmp
group by (log_id - rnk)