# Write your MySQL query statement below
select max(Salary) as SecondHighestSalary from Employee 
where Salary < (select max(Salary) from Employee)
--此处是一定要用max的，而不能
select Salary as SecondHighestSalary from Employee
where Salary < (select max(Salary) from Employee)
order by salary desc
limit 1
因为这样如果我们只有一个数，其实返回的是一个[],但是我们想要的是如果只有一个数，那么返回的是null


/* Write your T-SQL query statement below */
select Salary as SecondHighestSalary from
(select Salary, rank() over (order by Salary desc) as rnk from Employee) tmp
where rnk = 2
--上面这个情况是属于我们可以保证肯定有2nd的数。但是如果没有2nd呢？那么我们需要输出的是null，但是上面输出的是[]
--如果要达到上面的情况，我是觉得完全可以用case
select max(Salary) as SecondHighestSalary    --这里我们将Salary变成max()
from (SELECT salary, dense_rank() over(order by salary desc) as myrank
from Employee
) e
where myrank = 2;


#reference:
#https://www.cnblogs.com/0201zcr/p/4820706.html
