select
(ifnull(sum(b.apple_count),0) + ifnull(sum(c.apple_count),0)) as apple_count,
(ifnull(sum(b.orange_count),0) + ifnull(sum(c.orange_count),0)) as orange_count
-- 存在null值的加和还是需要用ifnull做处理
from Boxes b
left join Chests c on b.chest_id = c.chest_id


-- 用coalesce
-- ifnull和coalesce的区别：https://stackoverflow.com/questions/18528468/what-is-the-difference-between-ifnull-and-coalesce-in-mysql
select 
sum(boxes.apple_count  + COALESCE(Chests.apple_count, 0)) as apple_count,
sum(boxes.orange_count  + COALESCE(Chests.orange_count, 0)) as orange_count
from boxes left join Chests
on boxes.chest_id = chests.chest_id