-- 做这种和总体数进行比较的题，一般情况下就是要将原表和计算的总体平均数进行一个join
-- 然后对于这个join之后的表进行比较和处理

select business_id
from 
(
    select a.*,b.avg_tt from Events a left join
(select event_type,avg(occurences) as avg_tt from Events
group by 1)b
on a.event_type = b.event_type
)tmp
where occurences > avg_tt
group by business_id
having count(distinct event_type) > 1
