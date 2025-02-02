-- Mysql
select person_name from Queue
where turn =
(select a.turn from Queue a, Queue b
where a.turn >= b.turn
group by a.turn
having sum(b.weight)<=1000
order by a.turn desc limit 1)
/*这里相当于就是说，把小于a.turn的b.turn的重量加起来
因为a.turn >= b.turn，所以当a.turn = 1的时候，b.turn = 1，那么sum(b.weight)就是turn = 1的重量
当a.turn = 2的时候，b.turn <= 2，那么sum(b.weight)就是turn = 1+2的重量
当a.turn = 3的时候，b.turn <= 3，那么sum(b.weight)就是turn = 1+2+3的重量
所以抽出来的内容会是前三排的
而我最后用一个order by就是抽取最后一个turn也就是我们想要的内容*/



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


-- 下面这种方法应该更容易理解：
-- 我们用一个sum() over来统计重量
-- 然后只要保证这个统计的重量是小于1000的
-- 接着我们按照turn来排名，取1个就好
with raw_data as
(select person_name,
sum(weight) over (order by turn) as sum_weight from Queue)

select person_name from raw_data
where sum_weight <= 1000
order by sum_weight desc 
limit 1

-----------------------------------

-- Python
import pandas as pd

def last_passenger(queue: pd.DataFrame) -> pd.DataFrame:
    queue.sort_values('turn',inplace = True)
    queue['cum_sum'] = queue.weight.cumsum()
    queue = queue[queue['cum_sum'] <= 1000]
    return queue.tail(1)[['person_name']]