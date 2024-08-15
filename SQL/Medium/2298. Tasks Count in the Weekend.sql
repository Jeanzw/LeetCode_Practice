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
import numpy as np

def count_tasks(tasks: pd.DataFrame) -> pd.DataFrame:
    tasks['weekday'] = tasks['submit_date'].dt.weekday
    tasks['weekday'] = np.where((tasks['weekday'] >= 0) & (tasks['weekday'] <= 4),'working','weekend')
    working_cnt = tasks.query("weekday == 'working'").shape[0]
    weekend_cnt = tasks.query("weekday == 'weekend'").shape[0]
    return pd.DataFrame({'weekend_cnt':[weekend_cnt],'working_cnt':[working_cnt]})