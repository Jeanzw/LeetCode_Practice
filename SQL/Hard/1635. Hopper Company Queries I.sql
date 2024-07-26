with recursive month as
(select 1 as month union select month + 1 from month where month < 12)

, driver as
(select driver_id,
case when join_date <'2020-01-01' then 1
 else month(join_date) end as join_date
 from Drivers 
 where join_date <= '2020-12-31'
)
-- 下面两个cte是可以简化的
, ride as
(select ride_id,requested_at from Rides where requested_at between '2020-01-01' and '2020-12-31')

, accept_rides as
(select driver_id, a.ride_id,month(requested_at) as month from AcceptedRides a join ride r on a.ride_id = r.ride_id)

select 
m.month, 
count(distinct d.driver_id) as active_drivers,
count(distinct a.ride_id) as accepted_rides
-- # month, count(distinct driver_id)
from month m
left join driver d on m.month >= d.join_date
left join accept_rides a on m.month = a.month
group by 1


-- 简化后的版本：
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
    r.ride_id as accept_rides
 from Rides r
 join AcceptedRides a on r.ride_id = a.ride_id
 where year(requested_at) = 2020
 group by 1,2
)


select 
    m.month,
    count(distinct d.driver_id) as active_drivers,
    ifnull(count(distinct accept_rides),0) as accepted_rides
from month m
left join driver d on m.month >= d.month
left join acceptrides a on m.month = a.month
group by 1


-- 再简化：
-- 其实我们要知道对于ride这一块，因为就涉及当月的情况我们其实是可以和cte一起处理的
-- 但是对于driver来说是需要先进行处理，因为涉及到累积的问题
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
count(distinct d.driver_id) as active_drivers,
count(distinct c.ride_id) as accepted_rides
from cte a
left join Rides b on a.month = month(b.requested_at) and year(b.requested_at) = 2020
left join AcceptedRides c on b.ride_id = c.ride_id
left join driver d on a.month >= d.month 
group by 1


--  Python
import pandas as pd

def hopper_company(drivers: pd.DataFrame, rides: pd.DataFrame, accepted_rides: pd.DataFrame) -> pd.DataFrame:
    # 先弄一个大框架
    frame_month = pd.DataFrame({'month':range(1,13)})
    # 先对driver进行处理
    drivers['join_date'] = pd.to_datetime(drivers['join_date'])
    drivers = drivers.query("join_date.dt.year < 2021")
    drivers['month'] = np.where(drivers['join_date'].dt.year < 2020, 1, drivers['join_date'].dt.month)
    # 再对rides进行处理
    rides['requested_at'] = pd.to_datetime(rides['requested_at'])
    rides = rides.query("requested_at.dt.year == 2020")
    rides['month'] = rides['requested_at'].dt.month
    # 然后去计算被接受的单子的aggregation后的数据
    rides_accepted = pd.merge(accepted_rides,rides, on = 'ride_id', how = 'inner').groupby(['month'],as_index = False).ride_id.nunique()
    # 然后计算司机的aggregation之后的数据
    drivers = drivers.groupby(['month'], as_index = False).driver_id.nunique()
    # 最后做一个merge，将null值全部替换成0
    merge = pd.merge(frame_month,drivers,on = 'month', how = 'left').merge(rides_accepted, on = 'month', how = 'left').fillna(0)
    # 然后累计求和
    merge['active_drivers'] = merge['driver_id'].cumsum()
    return merge[['month','active_drivers','ride_id']].rename(columns = {'ride_id':'accepted_rides'})

