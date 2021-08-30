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