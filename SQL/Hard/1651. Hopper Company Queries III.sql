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