select min(log_id) as start_id,max(log_id) as end_id from 
(select *,row_number() over (order by log_id) as num from Logs)a
group by log_id - num

-- 其实也可以就用rank来做
select min(log_id) as start_id,max(log_id) as end_id from
(select log_id,rank() over (order by log_id) as rnk from Logs)tmp
group by (log_id - rnk)


-- Python
import pandas as pd

def find_continuous_ranges(logs: pd.DataFrame) -> pd.DataFrame:
    # Python和sql不一样，对于dataframe而言，原本就有一个index可以作为rank了
    # 那么我们只需要建立一个bridge，也就是logs['log_id'] - logs.index
    logs['diff'] = logs['log_id'] - logs.index
    # 接着就按照sql的逻辑来走，直接group by这个diff，然后取最大最小的log_id即可
    res = logs.groupby('diff').agg(
        start_id = ('log_id','min'),
        end_id = ('log_id','max')
    )
    return res