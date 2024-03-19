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