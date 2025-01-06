# Write your MySQL query statement below
with cte as
(select
a.fuel_type,
a.driver_id,
b.accidents,
round(avg(rating),2) as rating,
sum(distance) as distance
from Vehicles a
left join Drivers b on a.driver_id = b.driver_id
join Trips c on a.vehicle_id = c.vehicle_id
-- 如果眸中fuel_type不存在，那么直接忽略掉
group by 1,2,3)
, summary as
(select 
*,
row_number() over (partition by fuel_type order by rating desc, distance desc, accidents) as rnk
from cte)

select 
fuel_type,
driver_id,
rating,
distance 
from summary
where rnk = 1
order by 1




-- Python
import pandas as pd

def get_top_performing_drivers(drivers: pd.DataFrame, vehicles: pd.DataFrame, trips: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(vehicles,drivers,on = 'driver_id', how = 'left').merge(trips, on = 'vehicle_id')
    merge = merge.groupby(['fuel_type','driver_id','accidents'], as_index = False).agg(
        rating = ('rating','mean'),
        -- ('rating', lambda x: round(x.mean(), 2)), 这里也可以写成lambda的形式，这样子我们就不用在下面对rating进行四舍五入的处理了
        distance = ('distance','sum')
    )
    merge.sort_values(['fuel_type','rating','distance','accidents'], ascending = [1,0,0,1],inplace = True)
    res = merge.groupby(['fuel_type']).head(1)
    res['rating'] = res['rating'].round(2)
    return res[['fuel_type','driver_id','rating','distance']]