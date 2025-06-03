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
  -- 如果有overlap，那么end_day != maxx
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
  SELECT hall_id, start_day, end_day, 
  SUM(idk + CASE WHEN start_day <= lmaxx THEN 0 ELSE 1 END) OVER(PARTITION BY hall_id ORDER BY start_day) AS decision
  -- 也就是说，如果我们发现start_day <= lmaxx也就是说有overlap，然后我们就不增加数，如果没有overlap我们就增加一个数
  -- 通过这个decision的数字当做一个bridge，然后我们判断是否在一个时间范围内的
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

----------------------------

-- Python
import pandas as pd
import numpy as np

def merge_events(hall_events: pd.DataFrame) -> pd.DataFrame:
    hall_events.sort_values(['hall_id','start_day'], ascending = [1,1], inplace = True)
    hall_events['maxx'] = hall_events.groupby(['hall_id']).end_day.cummax()
    hall_events['lmaxx'] = hall_events.groupby(['hall_id']).maxx.shift(1)
    hall_events['flg'] = np.where(hall_events['start_day'] <= hall_events['lmaxx'], 0, 1)
    hall_events['decision'] = hall_events.groupby(['hall_id']).flg.cumsum()

    hall_events = hall_events.groupby(['hall_id','decision'], as_index = False).agg(
        start_day = ('start_day','min'),
        end_day = ('end_day','max')
    )

    return hall_events[['hall_id','start_day','end_day']]