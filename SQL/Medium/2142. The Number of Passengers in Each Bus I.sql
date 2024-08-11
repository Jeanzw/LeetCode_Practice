with bus_rank as
(select bus_id, arrival_time, row_number() over (order by arrival_time) as rnk from Buses)
-- 我们先做一个cte来把汽车到达时间排个序，我们不能直接用bus_id来排序，因为这个id可能是各种数字的组合
,bus_info as
(select
a.bus_id,
ifnull(b.arrival_time + 1,0) as start,
a.arrival_time as end
from bus_rank a
left join bus_rank b on a.arrival_time > b.arrival_time and a.rnk - 1 = b.rnk)

select
a.bus_id,
count(distinct b.passenger_id) as passengers_cnt
from bus_info a
left join Passengers b on b.arrival_time between a.start and a.end
group by 1
order by 1


-- 我觉得先排序再处理有点慢，直接lag解决
# Write your MySQL query statement below
with cte as
(select
*,
ifnull(lag(arrival_time,1) over (order by arrival_time),0) as last_time
from Buses )

select
a.bus_id,
count(distinct b.passenger_id) as passengers_cnt
from cte a
left join Passengers b on b.arrival_time <= a.arrival_time and b.arrival_time > a.last_time
group by 1
order by 1


-- Python
import pandas as pd

def count_passengers_in_bus(buses: pd.DataFrame, passengers: pd.DataFrame) -> pd.DataFrame:
    buses = buses.sort_values('arrival_time')
    buses['last_time'] = buses.arrival_time.shift(1).fillna(0)

    merge = pd.merge(buses,passengers, how = 'cross')
    merge = merge.query("arrival_time_y <= arrival_time_x and arrival_time_y > last_time")

    summary = merge.groupby(['bus_id'], as_index = False).agg(
        passengers_cnt = ('passenger_id','nunique')
    )

    res = pd.merge(buses,summary, on = 'bus_id', how = 'left').fillna(0)
    return res[['bus_id','passengers_cnt']].sort_values('bus_id')