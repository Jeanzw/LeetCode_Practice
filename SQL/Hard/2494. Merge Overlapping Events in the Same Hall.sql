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