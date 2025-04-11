select min(log_id) as start_id,max(log_id) as end_id from 
(select *,row_number() over (order by log_id) as num from Logs)a
group by log_id - num

-------------------------------------------------

-- 其实也可以就用rank来做
select min(log_id) as start_id,max(log_id) as end_id from
(select log_id,rank() over (order by log_id) as rnk from Logs)tmp
group by (log_id - rnk)

-------------------------------------------------

-- 还是用cte比较清楚一点
with cte as
(select
*,
log_id + 1 - row_number() over (order by log_id) as bridge
from Logs)

select
min(log_id) as start_id,
max(log_id) as end_id
from cte
group by bridge
order by 1

------------------------------------------------

-- Python
import pandas as pd

def find_continuous_ranges(logs: pd.DataFrame) -> pd.DataFrame:
    logs['bridge'] = logs['log_id'] - logs.log_id.rank(method = 'first')
    logs = logs.groupby(['bridge'],as_index = False).agg(
        start_id = ('log_id','min'),
        end_id = ('log_id','max')
    )
    return logs[['start_id','end_id']].sort_values('start_id')