# Write your MySQL query statement below
select max(Salary) as SecondHighestSalary from Employee 
where Salary < (select max(Salary) from Employee)
--此处是一定要用max或者min
select Salary as SecondHighestSalary from Employee
where Salary < (select max(Salary) from Employee)
order by salary desc
limit 1
--因为这样如果我们只有一个数，其实返回的是一个[],但是我们想要的是如果只有一个数，那么返回的是null
-- 为了达到上面的目的，我们需要对最后得出的数进行一个处理，比如说max或者min


/* Write your T-SQL query statement below */
select Salary as SecondHighestSalary from
(select Salary, rank() over (order by Salary desc) as rnk from Employee) tmp
where rnk = 2
--上面这个情况是属于我们可以保证肯定有2nd的数。但是如果没有2nd呢？那么我们需要输出的是null，但是上面输出的是[]
--那么下面的这种解法我们就加了一个max，其原理其实就是，如果这个数是不存在的情况下，那么我要去求max那么得出的结果是null，而单纯求这个数其实是不存在的，所以是空
select max(Salary) as SecondHighestSalary    --这里我们将Salary变成max()
from (SELECT salary, dense_rank() over(order by salary desc) as myrank
from Employee
) e
where myrank = 2;


-- 另外官方是给了这么一个方法
-- 在这里涉及offset的用法：https://www.jianshu.com/p/efecd0b66c55
SELECT
    (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary




#reference:
#https://www.cnblogs.com/0201zcr/p/4820706.html
