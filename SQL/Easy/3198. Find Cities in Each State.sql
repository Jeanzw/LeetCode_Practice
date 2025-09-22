select 
state,
group_concat(distinct city order by city separator ', ') as cities
-- 注意这里的分隔号是,+空格
from cities
group by 1
order by 1

----------------------------

-- Python
import pandas as pd

def find_cities(cities: pd.DataFrame) -> pd.DataFrame:
    cities = cities.sort_values(['state','city'])
    cities = cities.groupby(['state'],as_index = False).agg(cities = ('city',', '.join))
    return cities

-- 另外的做法
import pandas as pd

def find_cities(cities: pd.DataFrame) -> pd.DataFrame:
    cities = cities.groupby(['state'],as_index = False).agg(
        cities = ('city', lambda x: ', '.join(sorted(x)))
    )
    return cities.sort_values(['state'])