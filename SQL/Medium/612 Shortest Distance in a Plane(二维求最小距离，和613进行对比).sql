select round(sqrt(min(pow(a.x - b.x,2) + pow(a.y - b.y,2))),2) as shortest from point_2d a,point_2d b
where a.x != b.x or a.y != b.y

/*另一种做法*/
SELECT
    ROUND(SQRT(MIN((POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)))), 2) AS shortest
FROM
    point_2d p1
        JOIN
    point_2d p2 ON p1.x != p2.x OR p1.y != p2.y


-- Python
import pandas as pd
import numpy as np

def shortest_distance(point2_d: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(point2_d,point2_d,how = 'cross')
    merge = merge.query("x_x != x_y or y_x != y_y")
    merge['distance'] = np.sqrt((merge['x_x'] - merge['x_y']).pow(2) + (merge['y_x'] - merge['y_y']).pow(2)).round(2)
    shortest = merge.distance.min()
    return pd.DataFrame({'shortest':[shortest]})