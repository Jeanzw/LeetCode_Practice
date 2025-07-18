select distinct a.seat_id from cinema as a
join cinema as b
on abs(a.seat_id - b.seat_id) = 1 and a.free = 1 and b.free = 1
order by a.seat_id
/*如果不用abs()当然也是可以的，但是就是需要
a.seat_id = b.seat_id + 1 or a.seat_id = b.seat_id - 1这样的形式了
和601做一下对比*/

------------------------------

with raw_data as
(select * from cinema where free = 1)

select distinct r1.seat_id from raw_data r1
join raw_data r2 
on r1.seat_id + 1 = r2.seat_id or r2.seat_id + 1 = r1.seat_id
order by 1

------------------------------

-- 也可以用group by来做
with diff as
(select seat_id, seat_id - row_number() over (order by seat_id) as rnk
from cinema
where free = 1)

select seat_id from diff
where rnk in
(select rnk from diff group by 1 having count(*) >= 2)

------------------------------

-- Python
import pandas as pd

def consecutive_available_seats(cinema: pd.DataFrame) -> pd.DataFrame:
    cinema = cinema.query("free == 1")
    cinema['rnk'] = cinema.seat_id.rank()
    cinema['bridge'] = cinema['seat_id'] - cinema['rnk']
    bridge = cinema.groupby(['bridge'],as_index = False).seat_id.nunique()
    bridge = bridge.query("seat_id >= 2")[['bridge']]

    res = pd.merge(cinema,bridge,on = 'bridge')[['seat_id']].sort_values('seat_id')
    return res

------------------------------

-- 也可以这么做
import pandas as pd

def consecutive_available_seats(cinema: pd.DataFrame) -> pd.DataFrame:
    cinema = cinema[cinema['free'] == 1]
    cinema['bridge'] = cinema['seat_id'] - cinema.seat_id.rank()
    cinema['cnt_bridge'] = cinema.groupby(['bridge']).seat_id.transform('nunique')
    return cinema[cinema['cnt_bridge'] >= 2][['seat_id']].sort_values('seat_id')

------------------------------

-- 也可以这么做
import pandas as pd

def consecutive_available_seats(cinema: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(cinema,cinema, on = 'free')
    merge = merge[(merge['free'] == 1) & ((merge['seat_id_x'] + 1 == merge['seat_id_y']) | (merge['seat_id_x'] - 1 == merge['seat_id_y']))]
    return merge[['seat_id_x']].drop_duplicates().rename(columns = {'seat_id_x':'seat_id'}).sort_values(['seat_id'])