select 
a.driver_id,
count(distinct b.ride_id) as cnt
from Rides a
left join Rides b on a.driver_id = b.passenger_id
group by 1

---------------------------------

-- Python
import pandas as pd

def driver_passenger(rides: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(rides,rides, left_on = 'driver_id', right_on = 'passenger_id', how = 'left')
    summary = merge.groupby(['driver_id_x'], as_index = False).ride_id_y.nunique()
    return summary.rename(columns = {'driver_id_x':'driver_id','ride_id_y':'cnt'})