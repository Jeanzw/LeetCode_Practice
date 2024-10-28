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




-- Python
import pandas as pd
import numpy as np

def hopper_company_queries(drivers: pd.DataFrame, rides: pd.DataFrame, accepted_rides: pd.DataFrame) -> pd.DataFrame:
    month = pd.DataFrame({'month':range(1,13)})
# 先处理drivers的数量
    drivers = drivers.query("join_date.dt.year < 2021")
    drivers['active_month'] = np.where(drivers['join_date'].dt.year < 2020, 1, drivers['join_date'].dt.month)
    drivers = drivers.groupby(['active_month'],as_index = False).driver_id.nunique()
# 再出来被接受的ride
    acc_drive = pd.merge(rides,accepted_rides,on = 'ride_id').query("requested_at.dt.year == 2020")
    acc_drive['acc_month'] = acc_drive.requested_at.dt.month
    acc_drive = acc_drive.groupby(['acc_month'],as_index = False).driver_id.nunique()

# 最后将所有的内容结合起来
    res = pd.merge(month,drivers, left_on = 'month', right_on = 'active_month',how = 'left').merge(acc_drive,left_on = 'month', right_on = 'acc_month', how = 'left').fillna(0)
# 对司机的数量累计求和
    res['active_drivers'] = res.driver_id_x.cumsum()
    res['working_percentage'] = round(100 * res['driver_id_y']/res['active_drivers'],2).fillna(0)
    return res[['month','working_percentage']]