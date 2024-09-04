with nation as
(select avg(price) as nation_avg from Listings)
, city_avg as
(select
city, avg(price) as city_avg
from Listings
group by 1)

select
city
from city_avg,nation
where city_avg > nation_avg
order by 1

-- 其实可以直接一步到位
with cte as
(select
*,
avg(price) over (partition by city) as avg_city,
avg(price) over () as avg_nation
from Listings)

select distinct city from cte where avg_city > avg_nation order by 1


-- Python
import pandas as pd

def find_expensive_cities(listings: pd.DataFrame) -> pd.DataFrame:
    listings['city_avg'] = listings.groupby(['city']).price.transform(mean)
    listings['nation_avg'] = listings.price.mean()
    return listings.query("city_avg>nation_avg")[['city']].drop_duplicates().sort_values('city')