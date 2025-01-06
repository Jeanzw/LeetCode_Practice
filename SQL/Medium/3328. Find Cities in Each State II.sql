# Write your MySQL query statement below
with cte as
(select
state,
city,
count(city) over (partition by state) as city_count,
sum(case when left(state,1) = left(city,1) then 1 else 0 end) over (partition by state) as matching_letter_count
from cities
group by 1,2)

select 
state,
group_concat(distinct city order by city separator ', ') as cities,
matching_letter_count
from cte
where matching_letter_count > 0
and city_count >= 3
group by 1,3
order by 3 desc, 1


-- Python
import pandas as pd
import numpy as np

def state_city_analysis(cities: pd.DataFrame) -> pd.DataFrame:
    cities['city_cnt'] = cities.groupby(['state']).city.transform('nunique')
    cities['same_name'] = np.where(cities['state'].str[:1] == cities['city'].str[:1], cities['city'], None)
    cities['matching_letter_count'] = cities.groupby(['state']).same_name.transform('nunique')
    cities = cities[(cities['city_cnt'] >= 3) & (cities['matching_letter_count'] >= 1)]

    res = cities.groupby(['state','matching_letter_count'],as_index = False).agg(
        cities = ('city',lambda x:', '.join(sorted(x)))
    )
    return res[['state','cities','matching_letter_count']].sort_values(['matching_letter_count','state'], ascending = [0,1])