with cnt_passenger as
(select flight_id, count(distinct passenger_id) as cnt from Passengers group by 1)

select
a.flight_id,
case when b.flight_id is null then 0
     when capacity >= cnt then cnt 
     else capacity end as booked_cnt,
case when b.flight_id is null then 0
     when capacity >= cnt then 0 
     else cnt - capacity end as waitlist_cnt
from Flights a
left join cnt_passenger b on a.flight_id = b.flight_id
order by 1

---------------------------------

-- 直接一个query写下来就可以了
select
a.flight_id,
case when count(distinct passenger_id) <= capacity then count(distinct passenger_id) else capacity end as booked_cnt,
case when count(distinct passenger_id) <= capacity then 0 else count(distinct passenger_id) - capacity end as waitlist_cnt
from Flights a
left join Passengers b on a.flight_id = b.flight_id
group by 1
order by 1

---------------------------------

-- 上面用case when判断大小也可以改成用least()和greatest()
SELECT 
  f.flight_id, 
  LEAST(
    f.capacity, 
    COUNT(p.passenger_id)
  ) AS booked_cnt, 
  GREATEST(
    0, 
    COUNT(p.passenger_id) - f.capacity
  ) AS waitlist_cnt 
FROM 
  Flights f 
  LEFT JOIN Passengers p ON f.flight_id = p.flight_id 
GROUP BY 
  f.flight_id 
ORDER BY 
  f.flight_id;

---------------------------------

-- Python
import pandas as pd
import numpy as np

def waitlist_analysis(flights: pd.DataFrame, passengers: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(flights,passengers, on = 'flight_id', how = 'left')
    merge = merge.groupby(['flight_id','capacity'], as_index = False).passenger_id.nunique()
    merge['booked_cnt'] = np.where(merge['capacity'] >= merge['passenger_id'], merge['passenger_id'], merge['capacity'])
    merge['waitlist_cnt'] = np.where(merge['capacity'] >= merge['passenger_id'], 0, merge['passenger_id'] -merge['capacity'])

    return merge[['flight_id','booked_cnt','waitlist_cnt']].sort_values('flight_id')