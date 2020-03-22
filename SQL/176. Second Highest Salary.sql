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
select ifnull(Salary,null) as SecondHighestSalary from 
(select Salary,rank() over (order by Salary desc) as ranking from Employee)e
where ranking = 2


#reference:
#https://www.cnblogs.com/0201zcr/p/4820706.html
