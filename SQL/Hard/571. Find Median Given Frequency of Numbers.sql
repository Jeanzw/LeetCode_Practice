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



-- 其实我上面的方法我还是没有办法理解，所以这一次做我写了个自己的方法。也就是说我们用recursive把Frequency给展开，然后就是正常的求中位数的方法了
with recursive cte as
(select 
    Number,
    Frequency,
    1 as rnk from Numbers

 union all
 
 select 
    Number,
    Frequency,
    rnk + 1 as rnk
 from cte
 where rnk < Frequency
 
)


select avg(Number) as median from
(select 
    Number,
    row_number() over (order by Number) as rnk,
    count(*) over () as cnt
from cte
order by Number)tmp
where rnk between cnt/2 and cnt/2 + 1


-- 这道题和569不同的地方在于：
-- 1. 569是有一个Id作为一个定位的，而这道题如果我们用recursive那么最后也只有数字的排位
-- 数字的排位的问题在于，如果是569的情况：
-- ID      Number
-- 1         0
-- 2         0
-- 那么我们用rnk和rnk_desc是可以得到正反两个排位的
-- 但是对于这道题，因为我们没有Id作为定位，所以，我们在rnk以及rnk_desc其实是不清晰的，甚至只要是Number一样都是容易混乱的
-- 2. 由于上面的原因，我们这道题只能用count的window function来帮助我们解决这道题，也就是说，我们要理解median的意思，也就是中间两个数
-- 那么既然是中间两个数，如果我们得到了这组数一共有几个数，那么中间这个数应该是在cnt / 2 - 1 和 cnt / 2 + 1之间的
-- 但是我们要注意了，对于sql来说cnt / 2是自动往下取小的整数，也就是说在sql中cnt / 2已经是cnt / 2 - 1的结果了
-- 所以我们在最后的where里面其实需要区分一下



-- leetcode上面的最新做法
with cte AS
(
select 
    *, 
    sum(frequency) over(order by num) as freq, --这里相当于把这些数字累计求和
    (sum(frequency) over())/2 as median_num --这里相当于就是直接求出整张表的median，然后放在每一行后面作为index
from Numbers)

SELECT
round(avg(num),1) as median
from cte
where median_num between (freq - frequency) and freq