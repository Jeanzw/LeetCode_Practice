select
count(distinct case when weekday(submit_date) between 5 and 6 then task_id end) as weekend_cnt,
count(distinct case when weekday(submit_date) between 0 and 4 then task_id end) as working_cnt
from Tasks

-- 也可以用dayofweek()来做
select sum(case when dayofweek(submit_date) in (1, 7) then 1 else 0 end) as weekend_cnt,
       sum(case when dayofweek(submit_date) in (1, 7) then 0 else 1 end) as working_cnt
from tasks