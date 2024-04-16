select
distinct a.N,
case when a.P is null then 'Root'
     when b.P is null then 'Leaf'
     else 'Inner' end as Type
from Tree a
left join Tree b on a.N = b.P
order by 1