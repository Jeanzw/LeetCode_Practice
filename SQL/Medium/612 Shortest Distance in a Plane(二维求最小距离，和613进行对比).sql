select round(sqrt(min(pow(a.x - b.x,2) + pow(a.y - b.y,2))),2) as shortest from point_2d a,point_2d b
where a.x != b.x or a.y != b.y

/*另一种说法*/
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
    # Extract x and y coordinates as numpy arrays
    x = point2_d['x'].to_numpy()
    y = point2_d['y'].to_numpy()
    
    # Compute the pairwise squared distances using broadcasting
    dx = (x[:, None] - x[None, :])**2
    dy = (y[:, None] - y[None, :])**2
    distances_squared = dx + dy
    
    # Set diagonal to infinity to avoid zero distance for a point with itself
    np.fill_diagonal(distances_squared, np.inf)
    
    # Find the minimum distance
    min_distance_squared = np.min(distances_squared)
    
    # Take square root to get the Euclidean distance
    min_distance = np.sqrt(min_distance_squared)
    
    # Create a DataFrame to hold the result
    result_df = pd.DataFrame({'shortest': [round(min_distance, 2)]})
    
    return result_df
