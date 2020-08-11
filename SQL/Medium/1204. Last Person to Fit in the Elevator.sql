-- Mysql
select person_name from Queue
where turn =
(select a.turn from Queue a, Queue b
where a.turn >= b.turn
group by a.turn
having sum(b.weight)<=1000
order by a.turn desc limit 1)

-- select a.turn from Queue a, Queue b
-- where a.turn >= b.turn
-- {"headers": ["person_id", "person_name", "weight", "turn", "person_id", "person_name", "weight", "turn"], 
-- "values":   [5, "George Washington", 250, 1, 5, "George Washington", 250, 1], 

--             [3, "John Adams", 350, 2, 5, "George Washington", 250, 1], 
--             [3, "John Adams", 350, 2, 3, "John Adams", 350, 2],

--             [6, "Thomas Jefferson", 400, 3, 5, "George Washington", 250, 1],
--             [6, "Thomas Jefferson", 400, 3, 3, "John Adams", 350, 2],
--             [6, "Thomas Jefferson", 400, 3, 6, "Thomas Jefferson", 400, 3],

--             [2, "Will Johnliams", 200, 4, 5, "George Washington", 250, 1], 
--             [2, "Will Johnliams", 200, 4, 3, "John Adams", 350, 2], 
--             [2, "Will Johnliams", 200, 4, 2, "Will Johnliams", 200, 4], 
--             [2, "Will Johnliams", 200, 4, 6, "Thomas Jefferson", 400, 3],

--             [4, "Thomas Jefferson", 175, 5, 5, "George Washington", 250, 1], 
--             [4, "Thomas Jefferson", 175, 5, 4, "Thomas Jefferson", 175, 5], 
--             [4, "Thomas Jefferson", 175, 5, 3, "John Adams", 350, 2], 
--             [4, "Thomas Jefferson", 175, 5, 2, "Will Johnliams", 200, 4],
--             [4, "Thomas Jefferson", 175, 5, 6, "Thomas Jefferson", 400, 3],

--             [1, "James Elephant", 500, 6, 5, "George Washington", 250, 1], 
--             [1, "James Elephant", 500, 6, 4, "Thomas Jefferson", 175, 5],    
--             [1, "James Elephant", 500, 6, 3, "John Adams", 350, 2],
--             [1, "James Elephant", 500, 6, 6, "Thomas Jefferson", 400, 3], 
--             [1, "James Elephant", 500, 6, 2, "Will Johnliams", 200, 4],    
--             [1, "James Elephant", 500, 6, 1, "James Elephant", 500, 6], 
 


-- select * from Queue a, Queue b
-- where a.turn >= b.turn
-- group by a.turn
-- {"headers": ["person_id", "person_name", "weight", "turn", "person_id", "person_name", "weight", "turn"], 
-- "values":  [[5, "George Washington", 250, 1, 5, "George Washington", 250, 1], 
--             [4, "Thomas Jefferson", 175, 5, 5, "George Washington", 250, 1], 
--             [3, "John Adams", 350, 2, 5, "George Washington", 250, 1], 
--             [6, "Thomas Jefferson", 400, 3, 5, "George Washington", 250, 1], 
--             [1, "James Elephant", 500, 6, 5, "George Washington", 250, 1], 
--             [2, "Will Johnliams", 200, 4, 5, "George Washington", 250, 1]]}




-- select * from Queue a, Queue b
-- where a.turn >= b.turn
-- group by a.turn
-- having sum(b.weight)<=1000
-- {"headers": ["person_id", "person_name", "weight", "turn", "person_id", "person_name", "weight", "turn"], 
-- "values":  [[5, "George Washington", 250, 1, 5, "George Washington", 250, 1], 
--             [3, "John Adams", 350, 2, 5, "George Washington", 250, 1], 
--             [6, "Thomas Jefferson", 400, 3, 5, "George Washington", 250, 1]]}




-- MS SQL
-- 这里需要我们懂得用Top 1也就是排序的第一个
select top 1 person_name from
(select person_name, turn,
sum(weight) over (order by turn) as total_w
from Queue)tmp
where total_w <= 1000
order by total_w desc