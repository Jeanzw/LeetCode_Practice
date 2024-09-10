with cte as
(select
b.first_name,
a.type,
a.contact_id,
TIME_FORMAT(SEC_TO_TIME(duration), '%H:%i:%s') as duration_formatted,
rank() over (partition by a.type order by duration desc) as rnk
from Calls a
left join Contacts b on a.contact_id = b.id)

select first_name,type,duration_formatted from cte where rnk <= 3
order by 2 desc, 3 desc, 1 desc


-- Python
import pandas as pd

def find_longest_calls(contacts: pd.DataFrame, calls: pd.DataFrame) -> pd.DataFrame:
    calls['duration_formatted'] = pd.to_datetime(calls['duration'],unit = 's').dt.strftime('%H:%M:%S')
    merge = pd.merge(calls,contacts, left_on = 'contact_id', right_on = 'id', how = 'left').sort_values(['type','duration_formatted'], ascending = [0,0])
    merge = merge.groupby(['type']).head(3)
    return merge[['first_name','type','duration_formatted']]