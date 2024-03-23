with cte as
(select
*,
row_number() over (partition by city_id order by degree desc, day) as rnk
from Weather)

select city_id, day, degree from cte where rnk = 1 order by 1