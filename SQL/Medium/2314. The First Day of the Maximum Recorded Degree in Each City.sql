with cte as
(select
*,
row_number() over (partition by city_id order by degree desc, day) as rnk
from Weather)

select city_id, day, degree from cte where rnk = 1 order by 1

-----------------------

-- Python
import pandas as pd

def find_the_first_day(weather: pd.DataFrame) -> pd.DataFrame:
    weather = weather.sort_values(['city_id','degree','day'], ascending = [1,0,1])
    weather = weather.groupby(['city_id'],as_index = False).head(1)
    return weather