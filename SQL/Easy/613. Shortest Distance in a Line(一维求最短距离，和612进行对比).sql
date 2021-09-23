select min(abs(a.x - b.x)) as shortest 
from point a,point b
where a.x != b.x


-- 我其实觉得就算是用cross join也不要像上面那样子写
-- 如果真的用cross join也请写成cross join
select
min(abs(a.x - b.x)) as shortest
from point a
join point b on a.x != b.x