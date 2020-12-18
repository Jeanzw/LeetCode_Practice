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
(select driver_id, a.ride_id,month(requested_at) as month from AcceptedRides a join ride r on a.ride_id = r.ride_id)

select 
m.month, 
count(distinct d.driver_id) as active_drivers,
count(distinct a.ride_id) as accepted_rides
# month, count(distinct driver_id)
from month m
left join driver d on m.month >= d.join_date
left join accept_rides a on m.month = a.month
group by 1