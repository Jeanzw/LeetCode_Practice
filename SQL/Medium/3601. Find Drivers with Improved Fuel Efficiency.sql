with cte as
(select
a.driver_id,
a.driver_name,
case when month(trip_date) between 1 and 6 then 'first_half' else 'second_half' end as half,
avg(distance_km/fuel_consumed) as avg_fuel_efficiency
from drivers a
join trips b on a.driver_id = b.driver_id
group by 1,2,3)

select
a.driver_id,
a.driver_name,
round(a.avg_fuel_efficiency,2) as first_half_avg,
round(b.avg_fuel_efficiency,2) as second_half_avg,
round(b.avg_fuel_efficiency - a.avg_fuel_efficiency,2) as efficiency_improvement
from cte a
join cte b on a.driver_id = b.driver_id and a.half = 'first_half' and b.half = 'second_half' and a.avg_fuel_efficiency < b.avg_fuel_efficiency
order by 5 desc, 2

----------------------------

-- Python
import pandas as pd
import numpy as np

def find_improved_efficiency_drivers(drivers: pd.DataFrame, trips: pd.DataFrame) -> pd.DataFrame:
    trips['half'] = np.where((pd.to_datetime(trips['trip_date']).dt.month >= 1) & (pd.to_datetime(trips['trip_date']).dt.month <= 6),'first_half','second_half')
    trips['efficiency'] = trips['distance_km']/trips['fuel_consumed']
    summary = trips.groupby(['driver_id','half'], as_index = False).efficiency.mean()

    first_half = summary[summary['half'] == 'first_half']
    second_half = summary[summary['half'] == 'second_half']

    compare = pd.merge(first_half,second_half, on = 'driver_id')
    compare = compare[compare['efficiency_x'] < compare['efficiency_y']][['driver_id','efficiency_x','efficiency_y']]
    
    res = pd.merge(drivers,compare, on = 'driver_id').rename(columns = {'efficiency_x':'first_half_avg','efficiency_y':'second_half_avg'})
    res['efficiency_improvement'] = res['second_half_avg'] - res['first_half_avg']
    res['first_half_avg'] = res['first_half_avg'].round(2)
    res['second_half_avg'] = res['second_half_avg'].round(2)
    res['efficiency_improvement'] = res['efficiency_improvement'].round(2)
    return res.sort_values(['efficiency_improvement','driver_name'], ascending = [0,1])