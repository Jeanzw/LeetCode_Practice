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
 
select * from seq
where ids not in (select customer_id from Customers)
