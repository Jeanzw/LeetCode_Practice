select
a.member_id, a.name,
case when count(distinct b.visit_id) = 0 then 'Bronze'
     when 100 * count(distinct c.visit_id)/count(distinct b.visit_id) >= 80 then 'Diamond'
     when 100 * count(distinct c.visit_id)/count(distinct b.visit_id) >= 50 and 100 * count(distinct c.visit_id)/count(distinct b.visit_id) < 80 then 'Gold'
     else 'Silver' end as category
from Members a
left join Visits b on a.member_id = b.member_id
left join Purchases c on b.visit_id = c.visit_id
group by 1,2