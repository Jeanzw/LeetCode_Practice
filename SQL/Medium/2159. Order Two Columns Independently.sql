with first_ as
(select first_col, row_number() over (order by first_col) as rnk from Data)
, second_ as 
(select second_col, row_number() over (order by second_col desc) as rnk from Data)

select first_col,second_col
from first_ a
left join second_ b on a.rnk = b.rnk

----------------------------------------------

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

----------------------------------------------

-- Python
import pandas as pd

def order_two_columns(data: pd.DataFrame) -> pd.DataFrame:
    data['rnk1'] = data.first_col.rank(ascending = True, method = 'first')
    data['rnk2'] = data.second_col.rank(ascending = False, method = 'first')
    -- 我们这里一定一定要有Method = first，因为存在两个同样的数字
    
    merge = pd.merge(data,data, left_on = 'rnk1', right_on = 'rnk2')
    return merge[['first_col_x','second_col_y']].sort_values(['first_col_x','second_col_y'], ascending = [1,0]).rename(columns = {'first_col_x':'first_col','second_col_y':'second_col'})
    -- 我们最后排序的时候一定要把两列都排了，因为first_col_x会有一样的数字，如果我们不控制second_col_y，那么就会按照second_col_y从小到达排序