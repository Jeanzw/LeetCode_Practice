# Write your MySQL query statement below
select max(Salary) as SecondHighestSalary from Employee 
where Salary < (select max(Salary) from Employee)


/* Write your T-SQL query statement below */
select ifnull(Salary,null) as SecondHighestSalary from 
(select Salary,rank() over (order by Salary desc) as ranking from Employee)e
where ranking = 2


#reference:
#https://www.cnblogs.com/0201zcr/p/4820706.html