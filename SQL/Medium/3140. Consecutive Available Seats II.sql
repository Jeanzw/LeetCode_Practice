with cte as
(select
*,
seat_id - row_number() over (partition by free order by seat_id) as bridge
from Cinema where free = 1)
, summary as
(select
min(seat_id) as first_seat_id, 
max(seat_id) as last_seat_id, 
count(distinct seat_id) as consecutive_seats_len,
rank() over (order by count(distinct seat_id) desc) as rnk
from cte
group by free, bridge)

select first_seat_id,last_seat_id,consecutive_seats_len
from summary 
where rnk = 1
order by 1


-- Python
import pandas as pd

def consecutive_available_seats(cinema: pd.DataFrame) -> pd.DataFrame:
    cinema['free'] = cinema['free'].astype('int16')
    cinema = cinema.query("free == 1")
    cinema['bridge'] = cinema.seat_id.rank()
    cinema['bridge'] = cinema['seat_id'] - cinema['bridge']

    summary = cinema.groupby(['bridge'],as_index = False).agg(
        first_seat_id = ('seat_id','min'),
        last_seat_id = ('seat_id','max'),
        consecutive_seats_len = ('seat_id','nunique'),
    )
    summary['rnk'] = summary.consecutive_seats_len.rank(method = 'dense', ascending = False)
    return summary.query("rnk == 1")[['first_seat_id','last_seat_id','consecutive_seats_len']].sort_values('first_seat_id')
    