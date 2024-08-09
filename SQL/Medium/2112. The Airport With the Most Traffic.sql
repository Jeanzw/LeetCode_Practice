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



-- Python
import pandas as pd

def airport_with_most_traffic(flights: pd.DataFrame) -> pd.DataFrame:
    flights_1 = flights[['departure_airport','flights_count']].rename(columns = {'departure_airport':'airport_id'})
    flights_2 = flights[['arrival_airport','flights_count']].rename(columns = {'arrival_airport':'airport_id'})

    flight = pd.concat([flights_1,flights_2]).groupby(['airport_id'], as_index = False).flights_count.sum()
    flight['rnk'] = flight['flights_count'].rank(method = 'dense', ascending = False)

    return flight.query("rnk == 1")[['airport_id']]