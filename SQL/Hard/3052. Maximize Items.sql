with processing_data as
(select
item_type,
sum(square_footage) as storage,
count(distinct item_id) as item_num
from Inventory
group by 1)
, prime as
(select
item_type, 
floor(500000/storage) * item_num as item_count,
500000 - storage * floor(500000/storage) as remaining
from processing_data
where item_type = 'prime_eligible')
,not_prime as
(select 
item_type, (select remaining from prime),
floor((select remaining from prime)/storage) * item_num as item_count
from processing_data
where item_type = 'not_prime'
)

select item_type,item_count from
(select item_type,item_count from prime
union all
select item_type,item_count from not_prime) tmp
order by 2 desc


-- 这道题我不是觉得难，我是觉得烦。
-- 主要考察的还是思路，tech方面主要考察如何取整
-- 1.ROUND
-- ROUND：按照指定的精度进行四舍五入
-- 格式：round(数字，位数)
-- select round(58.436587,2) from dual -> 58.44

-- 2.TRUNC
-- TRUNC：按照指定的精度进行截取一个数
-- 格式：trunc（数字，位数）
-- select trunc(58.436587,2) from dual -> 58.43

-- 3.FLOOR
-- FLOOR：对给定的数字取整数位
-- 格式：floor(数字)
-- select FLOOR(58.436587) from dual -> 58

-- 4.CEIL
-- CEIL： 返回大于或等于给出数字的最小整数
-- 格式：ceil(数字)
-- select CEIL(58.436587) from dual -> 59


-- 下面是第二次做的比较简单的做法：
with cte as
(select
    item_type, 
    count(distinct item_id) as item_n, 
    sum(square_footage) as unit_square, 
    floor(500000/sum(square_footage)) * sum(square_footage) as square,
    floor(500000/sum(square_footage)) * count(distinct item_id) as item_count
from Inventory 
where item_type = 'prime_eligible'
group by 1)
, not_prime as
(select
item_type,
count(distinct item_id) as item_n, 
sum(square_footage) as unit_square
from Inventory 
where item_type = 'not_prime')

select item_type, item_count from
(select 
    item_type,
    floor((500000 - (select square from cte))/unit_square) * item_n as item_count 
from not_prime

union 

select 
    item_type,
    item_count
from cte)tmp
order by 2 desc




-- Python
import pandas as pd

def maximize_items(inventory: pd.DataFrame) -> pd.DataFrame:
    prime_eligible = inventory.query("item_type == 'prime_eligible'")
    prime_eligible = prime_eligible.groupby(['item_type'],as_index = False).agg(
        item_cnt = ('item_id','nunique'),
        unit_square = ('square_footage','sum')
    )
    prime_eligible['unit'] = floor(500000/prime_eligible['unit_square'])
    prime_eligible['tt_square'] = prime_eligible['unit_square'] * prime_eligible['unit']
    prime_eligible['item_count'] = prime_eligible['item_cnt'] * prime_eligible['unit']

    not_prime = inventory.query("item_type == 'not_prime'")
    not_prime = not_prime.groupby(['item_type'],as_index = False).agg(
        item_cnt = ('item_id','nunique'),
        unit_square = ('square_footage','sum')
    )
    not_prime['unit'] = floor((500000 - int(prime_eligible['tt_square']))/not_prime['unit_square'])
    not_prime['item_count'] = not_prime['item_cnt'] * not_prime['unit']


    concat = pd.concat([prime_eligible,not_prime])
    return concat[['item_type','item_count']].sort_values(['item_count'], ascending = False)