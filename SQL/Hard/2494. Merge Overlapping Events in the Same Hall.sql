-- 原数据集：
-- | hall_id | start_day  | end_day    |
-- | ------- | ---------- | ---------- |
-- | 1       | 2023-01-13 | 2023-01-14 |
-- | 1       | 2023-01-14 | 2023-01-17 |
-- | 1       | 2023-01-18 | 2023-01-25 |
-- | 2       | 2022-12-09 | 2022-12-23 |
-- | 2       | 2022-12-13 | 2022-12-17 |
-- | 3       | 2022-12-01 | 2023-01-30 |

WITH maxx AS (
  SELECT hall_id, start_day, end_day, MAX(end_day) OVER(PARTITION BY hall_id ORDER BY start_day) AS maxx
  FROM HallEvents
)

-- | hall_id | start_day  | end_day    | maxx       |
-- | ------- | ---------- | ---------- | ---------- |
-- | 1       | 2023-01-13 | 2023-01-14 | 2023-01-14 |
-- | 1       | 2023-01-14 | 2023-01-17 | 2023-01-17 |
-- | 1       | 2023-01-18 | 2023-01-25 | 2023-01-25 |
-- | 2       | 2022-12-09 | 2022-12-23 | 2022-12-23 |
-- | 2       | 2022-12-13 | 2022-12-17 | 2022-12-23 |
-- | 3       | 2022-12-01 | 2023-01-30 | 2023-01-30 |

,lagged AS (
  SELECT hall_id, start_day, end_day, LAG(maxx) OVER(PARTITION BY hall_id ORDER BY start_day) AS lmaxx, 0 as idk
  FROM maxx
)

-- | hall_id | start_day  | end_day    | lmaxx      | idk |
-- | ------- | ---------- | ---------- | ---------- | --- |
-- | 1       | 2023-01-13 | 2023-01-14 | null       | 0   |
-- | 1       | 2023-01-14 | 2023-01-17 | 2023-01-14 | 0   |
-- | 1       | 2023-01-18 | 2023-01-25 | 2023-01-17 | 0   |
-- | 2       | 2022-12-09 | 2022-12-23 | null       | 0   |
-- | 2       | 2022-12-13 | 2022-12-17 | 2022-12-23 | 0   |
-- | 3       | 2022-12-01 | 2023-01-30 | null       | 0   |

,decide AS (
  SELECT hall_id, start_day, end_day, SUM(idk + CASE WHEN start_day <= lmaxx THEN 0 ELSE 1 END) OVER(PARTITION BY hall_id ORDER BY start_day) AS decision
  FROM lagged
)

-- | hall_id | start_day  | end_day    | decision |
-- | ------- | ---------- | ---------- | -------- |
-- | 1       | 2023-01-13 | 2023-01-14 | 1        |
-- | 1       | 2023-01-14 | 2023-01-17 | 1        |
-- | 1       | 2023-01-18 | 2023-01-25 | 2        |
-- | 2       | 2022-12-09 | 2022-12-23 | 1        |
-- | 2       | 2022-12-13 | 2022-12-17 | 1        |
-- | 3       | 2022-12-01 | 2023-01-30 | 1        |


SELECT hall_id, MIN(start_day) AS start_day, MAX(end_day) AS end_day
FROM decide
GROUP BY hall_id, decision



-- Python
import pandas as pd
import numpy as np

def merge_events(hall_events: pd.DataFrame) -> pd.DataFrame:
    hall_events.sort_values(['hall_id','start_day'], inplace = True)
    hall_events['maxx'] = hall_events.groupby(['hall_id']).end_day.cummax()
    hall_events['lmaxx'] = hall_events.groupby(['hall_id']).maxx.shift(1)
    hall_events['idk'] = 0

    hall_events['flg'] = np.where(hall_events['start_day'] <= hall_events['lmaxx'], 0, 1)
    hall_events['flg'] = hall_events['flg'] + hall_events['idk']

    hall_events['bridge'] = hall_events.groupby(['hall_id']).flg.cumsum()

    res = hall_events.groupby(['hall_id','bridge'],as_index = False).agg(
        start_day = ('start_day','min'),
        end_day = ('end_day','max')
    )
    return res[['hall_id','start_day','end_day']]