with summary as
(select
a.*,
row_number() over (partition by flight_id order by booking_time) as rnk,
b.capacity
from Passengers a
left join Flights b on a.flight_id = b.flight_id)


select 
    passenger_id,
    case when rnk <= capacity then 'Confirmed'
         else 'Waitlist' end as Status
from summary
order by 1

-------------------------------

-- Python
import pandas as pd
import numpy as np

def ticket_status(flights: pd.DataFrame, passengers: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(flights,passengers,on = 'flight_id')
    merge['rnk'] = merge.groupby(['flight_id']).booking_time.rank()
    merge['Status'] = np.where(merge['capacity'] >= merge['rnk'], 'Confirmed','Waitlist')
    return merge[['passenger_id','Status']].sort_values('passenger_id')

-------------------------------

-- 另一种做法用cumcount()
import pandas as pd
import numpy as np

def ticket_status(flights: pd.DataFrame, passengers: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(passengers,flights,on = 'flight_id', how = 'left')
    merge.sort_values(['flight_id','booking_time'],inplace = True)
    merge['cumsum'] = merge.groupby(['flight_id']).passenger_id.cumcount() + 1
    merge['Status'] = np.where(merge['capacity'] >= merge['cumsum'],'Confirmed','Waitlist')
    return merge[['passenger_id','Status']].sort_values('passenger_id')