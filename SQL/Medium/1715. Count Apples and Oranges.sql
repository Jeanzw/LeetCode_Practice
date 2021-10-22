select
(ifnull(sum(b.apple_count),0) + ifnull(sum(c.apple_count),0)) as apple_count,
(ifnull(sum(b.orange_count),0) + ifnull(sum(c.orange_count),0)) as orange_count
-- 存在null值的加和还是需要用ifnull做处理
from Boxes b
left join Chests c on b.chest_id = c.chest_id