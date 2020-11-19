select class from courses 
group by 1
having count(distinct student) >= 5


-- 这道题我原本的解法是：
select class from courses 
group by 1
having count(*) >= 5
-- 这里出现的问题是：
-- {"headers": {"courses": ["student", "class"]}, 
--     "rows": {"courses": [["A", "Math"], 
--                         ["B", "English"], 
--                         ["C", "Math"], 
--                         ["D", "Biology"], 
--                         ["E", "Math"], 
--                         ["F", "Math"], 
--                         ["A", "Math"]]}}
-- 这里我们发现["A", "Math"]是重复值，那么如果直接count(*)就会报错
-- 所以在这里我们职能用count(distinct student)