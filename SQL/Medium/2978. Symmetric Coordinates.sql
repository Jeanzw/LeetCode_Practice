
-- 我们要注意的一点：可能会存在(6,6)这样的一组数据

with cte as
(select *, row_number() over () as rnk from Coordinates)


select
distinct a.x, a.y
from cte a
inner join cte b on a.x = b.y and a.y = b.x and a.x <= a.y and a.rnk != b.rnk
order by 1, 2

-------------------------------

-- Python

import pandas as pd

def symmetric_pairs(coordinates: pd.DataFrame) -> pd.DataFrame:
    coordinates['rnk'] = coordinates.index
    merge = pd.merge(coordinates,coordinates,left_on = ['X','Y'], right_on = ['Y','X'])
    merge = merge[(merge['X_x'] <= merge['Y_x']) & (merge['rnk_x'] != merge['rnk_y'])]
    return merge[['X_x','Y_x']].rename(columns = {'X_x':'X','Y_x':'Y'}).drop_duplicates().sort_values(['X','Y'])