with framework as
(select departure_airport as airport, flights_count from Flights
union all
select arrival_airport as airport, flights_count from Flights
)
, sum_rank as
(select
airport,
dense_rank() over (order by sum(flights_count) desc) as rnk
from framework group by 1
)

select distinct airport as airport_id from sum_rank where rnk = 1