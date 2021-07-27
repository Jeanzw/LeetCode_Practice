select min(Id) as Id, Company, Salary
from (select Id, Company, Salary, 
row_number() over(partition by Company order by Salary desc) row1, 
row_number() over(partition by Company order by Salary) row2
from employee) tmp
where row1 between row2-1 and row2+1
group by Company, Salary


/*另外的做法*/
-- mssql
select Id,Company,Salary from 
(select Id, Company,Salary,
row_number() over (partition by Company order by Salary,id) as row1
 row_number() over (partition by Company order by Salary desc,id desc) as row2 from Employee)tmp
--  之所以在排序的过程中，我们需要对id也进行排序
-- 这是因为我们希望,在同一家公司，如果人数为奇数，同时多人工资一样的情况下，我们会考虑id排序然后选择抽出中位数
 where row1 = row2 or abs(row1 - row2) = 1



-- 这种题还有另外一种套路
with t1 as(
select *, row_number() over(partition by Company order by Salary) as row,
count(Id) over(partition by Company) as cnt
from Employee )

select Id, Company, Salary
from t1
where row between cnt/2.0 and cnt/2.0+1;