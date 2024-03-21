select 
a.driver_id,
count(distinct b.ride_id) as cnt
from Rides a
left join Rides b on a.driver_id = b.passenger_id
group by 1