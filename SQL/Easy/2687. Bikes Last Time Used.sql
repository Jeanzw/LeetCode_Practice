select bike_number, max(end_time) as end_time
from Bikes
group by 1
order by 2 desc

-- Python
import pandas as pd

def last_used_time(bikes: pd.DataFrame) -> pd.DataFrame:
    bikes = bikes.groupby(['bike_number'],as_index = False).end_time.max()
    return bikes.sort_values(['end_time'],ascending = False)