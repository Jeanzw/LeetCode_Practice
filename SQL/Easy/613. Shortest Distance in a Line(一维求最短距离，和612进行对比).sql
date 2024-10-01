select min(abs(a.x - b.x)) as shortest 
from point a,point b
where a.x != b.x


-- 我其实觉得就算是用cross join也不要像上面那样子写
-- 如果真的用cross join也请写成cross join
select
min(abs(a.x - b.x)) as shortest
from point a
join point b on a.x != b.x


-- Python
import pandas as pd

def shortest_distance(point: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(point,point,how = 'cross')
    merge = merge.query('x_x != x_y')
    merge['distance'] = abs((merge['x_x'] - merge['x_y'])
    min_distance = merge['distance'].min()
    return pd.DataFrame({'shortest':[min_distance]})