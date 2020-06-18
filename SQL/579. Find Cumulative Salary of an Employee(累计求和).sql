select e1.Id,e1.Month, e1.Salary + IFNULL(e2.Salary,0) + IFNULL(e3.Salary,0) as Salary
from Employee as e1
left join Employee as e2 on e2.Id = e1.Id and e1.Month - 1 = e2.Month
left join Employee as e3 on e3.Id = e2.Id and e2.Month - 1 = e3.Month
where (e1.Id,e1.Month) not in (select Id,max(Month) from Employee Group by Id)
order by Id,Month desc
/*其实我是觉得这样子也行，不过就是不知道为什么这样子跑出来的数是和结果不同……但是结果明显计算有问题呀……*/
/*错误原因，题目中是说
Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months 
but exclude the most recent month.
也就是说，假设我们有五个月的数据，然后当我们到第四个月的时候，这里的累积量应该是第二个月第三个月第四个月的总和，而不包括第一个月
而如果是下面的写法其实我们是一直累计前面所有的内容
select Id, Month, Salary from
(select Id, Month, sum(Salary) over (partition by Id order by Month) as Salary,rank() over (partition by Id order by Month desc) as ranking from Employee)tmp
where ranking != 1
group by Id,Month,Salary
order by Id,Month desc
*/

/*但是如果真的要用MS SQL Server那么可以如下*/
select
    Id,
    Month,
    sum(Salary) over (partition by Id order by Month asc rows between 2 preceding and current row) Salary

from Employee E
where Month != ( select max(Month) from Employee EE where E.Id = EE.Id group by EE.Id  )
order by Id asc, Month desc