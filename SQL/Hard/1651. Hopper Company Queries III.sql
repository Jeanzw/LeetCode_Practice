with recursive month as
(select 1 as month union select month + 1 from month where month < 12)

,month_ride as
(select 
    r.ride_id,
    month(requested_at) as month,
    ride_distance,
    ride_duration
    from Rides r
    join AcceptedRides a on r.ride_id = a.ride_id
    where year(r.requested_at) = 2020)
, ride as  
(select 
    m.month,
    ifnull(sum(ride_distance),0) as distance,
    ifnull(sum(ride_duration),0) as duration
    from month m left join month_ride mr on m.month = mr.month
    group by 1)
    

select 
    a.month,
    round((a.distance + b.distance + c.distance)/3,2) as average_ride_distance,
    round((a.duration + b.duration + c.duration)/3,2) as average_ride_duration
    from ride a 
    left join ride b on a.month + 1 = b.month
    left join ride c on b.month + 1 = c.month
    where a.month <= 10

---------------------------------------

-- 或者我们不用join，直接用滚动window function
# Write your MySQL query statement below
with recursive month as
(select 1 as month
union all
 select month + 1 as month from month
 where month <= 11
)
,accept_ride as
(select 
    month(requested_at) as month,
    ride_distance,
    ride_duration
 from Rides r
 join AcceptedRides a on r.ride_id = a.ride_id
 where year(requested_at) = 2020
)
, month_ride as
(select
    m.month,
    sum(case when ride_distance is null then 0 else ride_distance end) as ride_distance,
    sum(case when ride_duration is null then 0 else ride_duration end) as ride_duration
    from month m
    left join accept_ride a on m.month = a.month
    group by 1)

select * from
(select 
    month,
    round(avg(ride_distance) over (order by month desc rows between 2 preceding and current row),2) as average_ride_distance,
    round(avg(ride_duration) over (order by month desc rows between 2 preceding and current row),2) as average_ride_duration
    from month_ride
    group by 1)tmp
    where month <= 10
    order by month

---------------------------------------

-- Python
import pandas as pd

def hopper_company_queries(drivers: pd.DataFrame, rides: pd.DataFrame, accepted_rides: pd.DataFrame) -> pd.DataFrame:
    # 建立month表
    month = pd.DataFrame({'month':range(1,13)})
    
    # 处理ride
    rides = rides[rides['requested_at'].dt.year == 2020]
    rides = pd.merge(rides,accepted_rides,on = 'ride_id')
    rides['month'] = rides.requested_at.dt.month
    rides = rides.groupby(['month'],as_index = False).agg(
        ride_distance = ('ride_distance','sum'),
        ride_duration = ('ride_duration','sum')
    )

    # 将月份和ride整合一起
    # 由于rolling是从这一行往上x行rolling，所以我们需要将month倒序
    merge = pd.merge(month,rides, on = 'month',how = 'left').fillna(0)
    merge.sort_values(['month'],ascending = False,inplace = True)
    # 最后进行rolling求数
    merge['average_ride_distance'] = merge.ride_distance.rolling(3).mean().fillna(0).round(2)
    merge['average_ride_duration'] = merge.ride_duration.rolling(3).mean().fillna(0).round(2)
    merge = merge[merge['month'] <= 10]
    return merge[['month','average_ride_distance','average_ride_duration']].sort_values('month')

---------------------------------------

-- 另外的做法
import pandas as pd

def hopper_company_queries(drivers: pd.DataFrame, rides: pd.DataFrame, accepted_rides: pd.DataFrame) -> pd.DataFrame:
    month = pd.DataFrame({'month':range(1,13)})
    rides = rides[rides['requested_at'].dt.year == 2020]
    rides['month'] = rides['requested_at'].dt.month
    accept_ride = pd.merge(rides, accepted_rides, on = 'ride_id')
    accept_ride = accept_ride.groupby(['month'],as_index = False).agg(
        ride_distance = ('ride_distance','sum'),
        ride_duration = ('ride_duration','sum')
    )

    res = pd.merge(month,accept_ride, on = 'month', how = 'left').fillna(0)
    res = pd.merge(res,res, how = 'cross').merge(res, how = 'cross')
    res = res[(res['month_x'] + 1 == res['month_y']) & (res['month_x'] + 2 == res['month'])]
    res['average_ride_distance'] = round((res['ride_distance_x'] + res['ride_distance_y'] + res['ride_distance'])/3,2)
    res['average_ride_duration'] = round((res['ride_duration_x'] + res['ride_duration_y'] + res['ride_duration'])/3,2)
    return res[['month_x','average_ride_distance','average_ride_duration']].rename(columns = {'month_x':'month'})