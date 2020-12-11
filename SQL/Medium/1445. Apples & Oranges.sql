select sale_date,
(sum(case when fruit = 'apples' then sold_num else 0 end) 
-
sum(case when fruit = 'oranges' then sold_num else 0 end)) as diff
from Sales
group by 1

-- 也可以直接用一个case when来处理
select 
sale_date,
sum(case when fruit = 'apples' then sold_num else -sold_num end) as diff
from Sales
group by 1
order by 1