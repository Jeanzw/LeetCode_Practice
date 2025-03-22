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

-----------------------------

-- 另外的做法
select
state,
group_concat(distinct city order by city separator ', ') as cities,
count(distinct case when left(state,1) = left(city,1) then city end) as matching_letter_count
from cities
group by 1
having matching_letter_count > 0
and count(distinct city) >= 3
order by 3 desc, 1

-----------------------------

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


-- 另外的做法
import pandas as pd
import numpy as np

def state_city_analysis(cities: pd.DataFrame) -> pd.DataFrame:
    cities['matching_city'] = np.where(cities['state'].str[0] == cities['city'].str[0], cities['city'], None)
    cities.sort_values(['state','city'],ascending = [1,1], inplace = True)
    cities = cities.groupby(['state'],as_index = False).agg(
        cities = ('city', lambda x: ', '.join(x)),
        matching_letter_count = ('matching_city','nunique'),
        total_city = ('city', 'nunique')
    )
    cities = cities[(cities['matching_letter_count'] > 0) & (cities['total_city'] >= 3)]
    return cities[['state','cities','matching_letter_count']].sort_values(['matching_letter_count','state'],ascending = [0,1])