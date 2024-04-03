with summary as
(select
a.*,
row_number() over (partition by flight_id order by booking_time) as rnk,
b.capacity
from Passengers a
left join Flights b on a.flight_id = b.flight_id)

select 
    passenger_id,
    case when rnk <= capacity then 'Confirmed'
         else 'Waitlist' end as Status
from summary
order by 1