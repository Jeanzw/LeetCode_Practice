with raw_data as
(select * from
(select from_id as person1, to_id as person2,duration from Calls
union all 
select to_id as person1, from_id as person2,duration from Calls)tmp
where person1 < person2)

select person1,person2,count(*) as call_count,sum(duration) as total_duration from raw_data
group by 1,2


-- 其实我觉得不必这么麻烦，直接一个case when解决了
select 
    case when from_id < to_id then from_id else to_id end as person1,
    case when from_id > to_id then from_id else to_id end as person2,
    count(*) as call_count,
    sum(duration) as total_duration
    from Calls
    group by 1,2



-- Python
import pandas as pd
import numpy as np

def number_of_calls(calls: pd.DataFrame) -> pd.DataFrame:
    calls['person1'] = np.where(calls['from_id'] < calls['to_id'],calls['from_id'],calls['to_id'])
    calls['person2'] = np.where(calls['from_id'] > calls['to_id'],calls['from_id'],calls['to_id'])

    calls = calls.groupby(['person1','person2'],as_index = False).agg(
        call_count = ('person1','count'),
        total_duration = ('duration','sum'),
    )

    return calls