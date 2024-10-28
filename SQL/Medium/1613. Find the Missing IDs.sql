-- 四种方式去创造连续数
-- https://leetcode.com/problems/find-the-missing-ids/discuss/890608/MySQL-4-solutions-to-generate-consecutive-sequence
-- 最推荐的方式也是比较容易理解的方式：
-- WITH RECURSIVE seq AS (
--     SELECT 0 AS value UNION ALL SELECT value + 1 FROM seq WHERE value < 100
--     )

-- SELECT * FROM seq;

with recursive seq as
(select 1 as ids 
 union  select ids + 1 from seq 
 where ids < (SELECT MAX(customer_id) FROM Customers))  
 --这里我们需要用<而不是<=，因为我们如果用后者，那么比如说最大值是5，但是这个时候我们的ids当他是5的时候会再进入循环一圈，从而导致ids变成了6
 
select * from seq
where ids not in (select customer_id from Customers)




-- 也可以用join来做
with recursive cte as
(select 1 as id
 union all
 select id + 1 as id from cte
where id < (select max(customer_id) from Customers)
)

select id as ids
from cte
left join Customers c on cte.id = c.customer_id
where c.customer_id is null
order by 1



-- Python
import pandas as pd

def find_missing_ids(customers: pd.DataFrame) -> pd.DataFrame:
    max_number = customers.customer_id.max()
    df = pd.DataFrame({'ids': range(1, max_number + 1)})
    merge = pd.merge(df,customers, left_on = 'ids', right_on = 'customer_id', how = 'left')
    merge = merge.query("customer_id.isna()")
    return merge[['ids']].sort_values('ids')