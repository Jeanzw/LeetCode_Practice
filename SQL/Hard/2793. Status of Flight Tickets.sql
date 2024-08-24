with summary as
(select
a.*,
row_number() over (partition by flight_id order by booking_time) as rnk,
b.capacity
from Passengers a
inner join Flights b on a.flight_id = b.flight_id)
-- 这里要用inner，因为存在在Passengers里面出现的flightid不在Flights表里面的情况（虽然我觉得这个情况过于扯淡……）

select 
    passenger_id,
    case when rnk <= capacity then 'Confirmed'
         else 'Waitlist' end as Status
from summary
order by 1


-- Python
import pandas as pd
import numpy as np

def ticket_status(flights: pd.DataFrame, passengers: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(flights,passengers,on = 'flight_id')
    merge['rnk'] = merge.groupby(['flight_id']).booking_time.rank()
    merge['Status'] = np.where(merge['capacity'] >= merge['rnk'], 'Confirmed','Waitlist')
    return merge[['passenger_id','Status']].sort_values('passenger_id')