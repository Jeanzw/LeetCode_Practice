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