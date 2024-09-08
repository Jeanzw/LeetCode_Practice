WITH RECURSIVE height_levels AS (
  SELECT MIN(height) AS level
  FROM heights
  UNION ALL
  SELECT level + 1
  FROM height_levels
  WHERE level < (SELECT MAX(height) FROM heights)
),
water_calculated AS (
  SELECT 
    h.level,
    (MAX(id) - MIN(id) - COUNT(id) + 1) AS water
  FROM 
    height_levels h
  JOIN 
    heights ON heights.height >= h.level
  GROUP BY 
    h.level
)
SELECT sum(water) as total_trapped_water FROM water_calculated;


-- 不能理解的解法
WITH CTE AS (
    SELECT *,
        MAX(height) OVER(ORDER BY id ASC) AS left_highest_bar,
        MAX(height) OVER(ORDER BY id DESC) AS right_highest_bar
    FROM Heights
)
SELECT SUM(LEAST(left_highest_bar, right_highest_bar) - height) AS total_trapped_water -- MIN() get smallest in a column, LEAST() get smallest among X values put in the function
FROM CTE


-- Python
import pandas as pd
import numpy as np

def calculate_trapped_rain_water(heights: pd.DataFrame) -> pd.DataFrame:
    A = np.minimum(heights.height.cummax(), heights.height[::-1].cummax())
    return pd.DataFrame({
        'total_trapped_water': [np.maximum(A - heights.height, 0).sum()]
    })