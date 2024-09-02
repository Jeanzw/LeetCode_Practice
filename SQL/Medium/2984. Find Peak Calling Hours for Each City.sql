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


-- Python
import pandas as pd

def peak_calling_hours(calls: pd.DataFrame) -> pd.DataFrame:
    calls['hour'] = calls['call_time'].dt.hour
    summary = calls.groupby(['city','hour'],as_index = False).size()
    summary['rnk'] = summary.groupby(['city'])['size'].rank(method = 'dense', ascending = False)
    return summary.query("rnk == 1")[['city','hour','size']].rename(columns = {'hour':'peak_calling_hour','size':'number_of_calls'}).sort_values(['peak_calling_hour','city'],ascending = [0,0])