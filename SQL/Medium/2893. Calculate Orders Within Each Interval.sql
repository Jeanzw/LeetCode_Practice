with recursive framework as
(select 1 as start, 6 as end, 1 as interval_no
union all
select start + 6 as start, end + 6 as end, interval_no + 1 as interval_no 
from framework
where start + 6 < (select max(minute) from Orders)
)

select
a.interval_no,
sum(order_count) as total_orders
from framework a
left join Orders b on b.minute between a.start and a.end
group by 1
order by 1

-------------------------------------------------------

-- 也可以先把最大interval no给求出来
with recursive cte as
(select ceil(max(minute)/6) as max_interval from Orders)
, frame as
(select 1 as interval_no, 1 as start, 6 as end
union all
select interval_no + 1 as interval_no, start + 6 as start, end + 6 as end 
from frame where interval_no < (select max_interval from cte)
)

select 
a.interval_no,
sum(order_count) as total_orders
from frame a
left join Orders b on b.minute between a.start and a.end
group by 1

-------------------------------------------------------
-- Python

import pandas as pd

def calculate_runs(orders: pd.DataFrame) -> pd.DataFrame:
    frame = pd.DataFrame({'interval_no':range(1, ceil(orders['minute'].max()/6) + 1)})
    orders['interval_no'] = ((orders['minute'] - 1) // 6) + 1

    res = pd.merge(frame, orders, on = 'interval_no', how = 'left').fillna(0)
    res = res.groupby(['interval_no'],as_index = False).order_count.sum()
    return res.rename(columns = {'order_count':'total_orders'}).sort_values('interval_no')