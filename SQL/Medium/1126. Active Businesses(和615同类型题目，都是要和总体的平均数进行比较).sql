select business_id from Events a
left join (select event_type,avg(occurences) as average from Events
          group by event_type)b
on a.event_type = b.event_type
where a.occurences > average
group by a.business_id
having count(*) > 1

----------------------------------

-- 用cte会更加简洁明了
with average as 
(select event_type, avg(occurences) as avg_occu from Events
group by 1)
-- 这里我们相当于就是计算了各个event_type的平均数

select business_id
from Events e left join average a on e.event_type = a.event_type  -- 用left join或者join都可以
where occurences > avg_occu
group by 1
having count(*) > 1
-- 将平均数和原表join，那么我们就可以直接比较了

----------------------------------

-- 我觉得直接用window function就可以解决了
with cte as
(select
*,
avg(occurrences) over (partition by event_type) as avg_activity
from Events)

select
business_id
from cte
where occurrences > avg_activity
group by 1
having count(distinct event_type) > 1

----------------------------------


-- Python
import pandas as pd

def active_businesses(events: pd.DataFrame) -> pd.DataFrame:
    events['avg_across'] = events.groupby(['event_type']).occurrences.transform('mean')
    events = events[events['occurrences'] > events['avg_across']]
    events = events.groupby(['business_id'],as_index = False).event_type.nunique()
    events = events[events['event_type'] > 1]
    return events[['business_id']]