select sale_date,
(sum(case when fruit = 'apples' then sold_num else 0 end) 
-
sum(case when fruit = 'oranges' then sold_num else 0 end)) as diff
from Sales
group by 1