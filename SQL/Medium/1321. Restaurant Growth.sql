-- MS SQL
select visited_on, 
sum(sum(amount)) over (order by visited_on rows between 6 preceding and current row) as amount,
-- 上面原本sql function的处理是只有一个sum()，但是这里我们在外面再加一个sum就是因为我们每个日子只能有一条数据，所以需要将date给group by起来
-- 但是如果是原本的只有一个sum()，那么其实group by是处理不了的，因为这里并不认为是求和的形式
round(sum(sum(amount)) over (order by visited_on rows between 6 preceding and current row) / 7.0,2) as average_amount
from Customer
group by visited_on
order by visited_on  --有了order by才会按照时间顺序来加起来
offset 6 rows


-- MYSQL
SELECT 
    a.visited_on, 
    SUM(b.amount) AS amount, 
    ROUND(SUM(b.amount)/7, 2) AS average_amount
FROM 
    (SELECT DISTINCT visited_on FROM Customer) a  --distinct date is required 
    JOIN Customer b ON DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
GROUP BY a.visited_on
HAVING a.visited_on >= MIN(b.visited_on) + 6;