-- 这道题的确符合hard
-- 首先我们如何自动建立一个表格里面有1月到12月的月份
-- 另外对于Drivers这一张表，我们需要知道这个表里面的日期其实是具有连续性的，也就是说，如果1月加入，那么整个2020年他都在存在的


with recursive month as
(select 1 as month union select month + 1 from month where month < 12)

, driver as
(select driver_id,
case when join_date <'2020-01-01' then 1
 else month(join_date) end as join_date
 from Drivers 
 where join_date <= '2020-12-31'
)
, ride as
(select ride_id,requested_at from Rides where requested_at between '2020-01-01' and '2020-12-31')

, accept_rides as
(select driver_id, month(requested_at) as month from AcceptedRides a join ride r on a.ride_id = r.ride_id)

select m.month, round(ifnull(100 * count(distinct a.driver_id)/count(distinct d.driver_id),0),2) as working_percentage
# month, count(distinct driver_id)
from month m
left join driver d on m.month >= d.join_date
left join accept_rides a on m.month = a.month
group by 1

------------------------------------------------------------

-- 和I一样，简化最后两个cte
with recursive month as
(select 1 as month
union all
select month + 1 as month from month
 where month<= 11
)
, driver as
(select 
    driver_id,
    case when year(join_date) < 2020 then 1 else month(join_date) end as month
 from Drivers
 where join_date <= '2020-12-31'
)
, acceptrides as
(select 
    month(requested_at) as month,
    a.driver_id
 from Rides r
 join AcceptedRides a on r.ride_id = a.ride_id
 where year(requested_at) = 2020
 group by 1,2
)

select 
    m.month,
    ifnull(round(100 * count(distinct a.driver_id)/count(distinct d.driver_id),2),0.00) as working_percentage
    from month m
    left join driver d on m.month >= d.month
    left join acceptrides a on m.month = a.month
    group by 1

------------------------------------------------------------

-- 和上面一个题目一样，再次简化：
with recursive cte as
(select 1 as month
union all
select month + 1 as month from cte where month <12
)
, driver as
(select 
driver_id,
case when year(join_date) < 2020 then 0 else month(join_date) end as month
from Drivers
where year(join_date) <= 2020
)

select
a.month,
round(100 * case when count(distinct d.driver_id) = 0 then 0 else
count(distinct c.driver_id)/count(distinct d.driver_id) end,2) as working_percentage


from cte a
left join Rides b on a.month = month(b.requested_at) and year(b.requested_at) = 2020
left join AcceptedRides c on b.ride_id = c.ride_id
left join driver d on a.month >= d.month 
group by 1

------------------------------------------------------------

-- 或者我们直接用window Function来求，而不是用a.month >= d.month
With recursive cte as
(select 1 as month
union all
select month + 1 as month from cte where month < 12
)
, driver as
(select
case when year(join_date) < 2020 then 1 else month(join_date) end as month,
count(distinct driver_id) as active_drivers
from Drivers
where year(join_date) <= 2020
group by 1)
, accept_ride as
(select 
month(requested_at) as month,
count(distinct driver_id) as accepted_drivers
from Rides a
join AcceptedRides b on a.ride_id = b.ride_id
where year(a.requested_at) = 2020
group by 1)
, summary as
(select
a.month,
ifnull(b.accepted_drivers,0) as accepted_drivers,
sum(active_drivers) over (order by a.month) as active_drivers
from cte a
left join accept_ride b on a.month = b.month
left join driver c on a.month = c.month)

select 
month,
ifnull(round(100 * accepted_drivers/active_drivers,2),0) as working_percentage
from summary

------------------------------------------------------------

-- Python
import pandas as pd
import numpy as np

def hopper_company_queries(drivers: pd.DataFrame, rides: pd.DataFrame, accepted_rides: pd.DataFrame) -> pd.DataFrame:
    frame = pd.DataFrame({'month':range(1,13)})
# 先处理drivers的数量
    drivers = drivers[drivers['join_date'] <= '2020-12-31']
    drivers['month'] = np.where(drivers['join_date'].dt.year < 2020, 1, drivers['join_date'].dt.month)
    drivers = drivers.groupby(['month'],as_index = False).driver_id.nunique()
# 再出来被接受的ride
    rides = rides[rides['requested_at'].dt.year == 2020]
    accept_ride = pd.merge(rides,accepted_rides,on = 'ride_id')
    accept_ride['month'] = accept_ride.requested_at.dt.month
    accept_ride = accept_ride.groupby(['month'],as_index = False).driver_id.nunique()
# 最后将所有的内容结合起来    
    res = pd.merge(frame,drivers, on = 'month', how = 'left').merge(accept_ride, on = 'month', how = 'left').fillna(0)
# 对司机的数量累计求和
    res['active_drivers'] = res.driver_id_x.cumsum()
    res['working_percentage'] = (100 * res['driver_id_y'] / res['active_drivers']).round(2)
    return res[['month','working_percentage']].fillna(0).sort_values('month')