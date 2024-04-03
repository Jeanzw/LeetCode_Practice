with cnt_passenger as
(select flight_id, count(distinct passenger_id) as cnt from Passengers group by 1)

select
a.flight_id,
case when b.flight_id is null then 0
     when capacity >= cnt then cnt 
     else capacity end as booked_cnt,
case when b.flight_id is null then 0
     when capacity >= cnt then 0 
     else cnt - capacity end as waitlist_cnt
from Flights a
left join cnt_passenger b on a.flight_id = b.flight_id
order by 1


-- 上面用case when判断大小也可以改成用least()和greatest()
SELECT 
  f.flight_id, 
  LEAST(
    f.capacity, 
    COUNT(p.passenger_id)
  ) AS booked_cnt, 
  GREATEST(
    0, 
    COUNT(p.passenger_id) - f.capacity
  ) AS waitlist_cnt 
FROM 
  Flights f 
  LEFT JOIN Passengers p ON f.flight_id = p.flight_id 
GROUP BY 
  f.flight_id 
ORDER BY 
  f.flight_id;



-- Python
import pandas as pd

def waitlist_analysis(flights: pd.DataFrame, passengers: pd.DataFrame) -> pd.DataFrame:
    passengers = (
        passengers.groupby(by="flight_id")
        .agg(cnt=("passenger_id", "nunique"))
        .reset_index()
    )
    passengers = flights.merge(passengers, on="flight_id", how="left").fillna(0)
    passengers["booked_cnt"] = passengers.apply(lambda row: min(row["cnt"], row["capacity"]), axis=1)
    passengers["waitlist_cnt"] = passengers["cnt"] - passengers["booked_cnt"]
    return passengers.drop(["cnt", "capacity"], axis=1).sort_values(by="flight_id")
