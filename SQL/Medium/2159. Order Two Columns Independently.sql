with first_ as
(select first_col, row_number() over (order by first_col) as rnk from Data)
, second_ as 
(select second_col, row_number() over (order by second_col desc) as rnk from Data)

select first_col,second_col
from first_ a
left join second_ b on a.rnk = b.rnk

-- 实在没必要用两个cte
with frame as
(select 
*,
row_number() over (order by first_col) as first_rnk,
row_number() over (order by second_col desc) as second_rnk
from Data
)

select 
a.first_col,
b.second_col
from frame a
inner join frame b on a.first_rnk = b.second_rnk
order by a.first_rnk


-- Python
import pandas as pd

def order_two_columns(data: pd.DataFrame) -> pd.DataFrame:
    data['first_rank'] =  data['first_col'].rank(method = 'first')
    data['second_rank'] =  data['second_col'].rank(method = 'first',ascending = False)
    merge = pd.merge(data,data,left_on = 'first_rank',right_on = 'second_rank').sort_values('first_col_x')
    return merge[['first_col_x','second_col_y']].sort_values(['first_col_x','second_col_y'], ascending = [1,0]).rename(columns = {'first_col_x':'first_col','second_col_y':'second_col'})