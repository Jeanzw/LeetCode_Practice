with cte as
(select *, row_number() over () as rnk from Coordinates)


select
distinct a.x, a.y
from cte a
inner join cte b on a.x = b.y and a.y = b.x and a.x <= a.y and a.rnk != b.rnk
order by 1, 2