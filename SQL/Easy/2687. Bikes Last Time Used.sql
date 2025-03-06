select bike_number, max(end_time) as end_time
from Bikes
group by 1
order by 2 desc

--------------------

-- Python
import pandas as pd

def last_used_time(bikes: pd.DataFrame) -> pd.DataFrame:
    bikes = bikes.groupby(['bike_number'],as_index = False).agg(
        end_time = ('end_time','max'),
        ride_id = ('ride_id','nunique')
    )
    return bikes.sort_values(['end_time','ride_id'],ascending = [0,0])[['bike_number','end_time']]



-- 另一种做法
import pandas as pd

def last_used_time(bikes: pd.DataFrame) -> pd.DataFrame:
    bikes.sort_values(['bike_number','end_time'],ascending = [1,0],inplace = True)
    bikes = bikes.groupby(['bike_number'],as_index = False).head(1)
    return bikes[['bike_number','end_time']].sort_values(['end_time'],ascending = False)