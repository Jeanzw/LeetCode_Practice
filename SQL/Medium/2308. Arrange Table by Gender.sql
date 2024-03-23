with cte as
(select
*,
row_number() over (partition by gender order by user_id) as rnk,
case when gender = 'female' then 1
     when gender = 'other' then 2
     else 3 end as cate_rnk
from Genders)

select user_id, gender 
from cte
order by rnk, cate_rnk