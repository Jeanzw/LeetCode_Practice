with cte as
(select *, row_number() over () as rnk from Coordinates)


select
distinct a.x, a.y
from cte a
inner join cte b on a.x = b.y and a.y = b.x and a.x <= a.y and a.rnk != b.rnk
order by 1, 2


-- Python
import pandas as pd

def symmetric_pairs(coordinates: pd.DataFrame) -> pd.DataFrame:
    coordinates['rnk'] = coordinates.index
    merge = pd.merge(coordinates,coordinates,how = 'cross')
    merge = merge.query("rnk_x != rnk_y and X_x == Y_y and Y_x == X_y and X_x <= Y_x")
    return merge[['X_x','Y_x']].drop_duplicates().rename(columns = {'X_x':'x','Y_x':'y'}).sort_values(['x','y'])