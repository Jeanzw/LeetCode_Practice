select
count(distinct case when weekday(submit_date) between 5 and 6 then task_id end) as weekend_cnt,
count(distinct case when weekday(submit_date) between 0 and 4 then task_id end) as working_cnt
from Tasks

-- 也可以用dayofweek()来做
select sum(case when dayofweek(submit_date) in (1, 7) then 1 else 0 end) as weekend_cnt,
       sum(case when dayofweek(submit_date) in (1, 7) then 0 else 1 end) as working_cnt
from tasks



-- Python
import pandas as pd

def count_tasks(tasks: pd.DataFrame) -> pd.DataFrame:
    tasks['weekday'] = tasks.submit_date.dt.weekday
    
    weekday = tasks[tasks['weekday'] <= 4].task_id.nunique()
    weekend = tasks[tasks['weekday'] > 4].task_id.nunique()
    return pd.DataFrame({'weekend_cnt':[weekend],'working_cnt':[weekday]})