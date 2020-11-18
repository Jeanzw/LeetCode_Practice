-- 这道题和569有一点像
select avg(Number*1.0) as median from
-- 先将前后的rnk给选出来
(SELECT Number, Frequency,
             SUM(Frequency) OVER (ORDER BY Number ASC) rk1,
             SUM(Frequency) OVER (ORDER BY Number DESC) rk2
             FROM Numbers)tmp
             where abs(rk1 - rk2) <= Frequency


select avg(n.Number) median
from Numbers n
where n.Frequency >= 
abs((select sum(Frequency) from Numbers where Number<=n.Number) -
(select sum(Frequency) from Numbers where Number>=n.Number))

-- Let's take all numbers from left including current number and then do same for right.
-- (select sum(Frequency) from Numbers where Number<=n.Number) as left
-- (select sum(Frequency) from Numbers where Number>=n.Number) as right
-- Now if difference between Left and Right less or equal to Frequency of the current number that means this number is median.
-- Ok, what if we get two numbers satisfied this condition?

-- try to explain this in a hopefully clearer way.
-- suppose number x has frequency of n, and total frequency of other numbers that are on its left is l, on its right is r.
-- the equation above is (n+l) - (n+r) = l - r, x is median if l==r, of course.
-- When l != r, as long as n can cover the difference, x is the median. 

