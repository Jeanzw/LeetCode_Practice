with cte as
(select
*,
row_number() over (partition by city_id order by degree desc, day) as rnk
from Weather)

select city_id, day, degree from cte where rnk = 1 order by 1


-- Python
import pandas as pd

def find_the_first_day(weather: pd.DataFrame) -> pd.DataFrame:
    weather = weather.sort_values(['city_id','degree','day'], ascending = [1,0,1])
    weather['rnk'] = weather.groupby(['city_id']).degree.rank(method = 'first', ascending = False)
    return weather.query("rnk == 1")[['city_id','day','degree']]