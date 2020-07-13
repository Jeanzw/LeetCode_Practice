select min(Id) as Id, Company, Salary
from (select Id, Company, Salary, 
row_number() over(partition by Company order by Salary desc) row1, 
row_number() over(partition by Company order by Salary) row2
from employee) tmp
where row1 between row2-1 and row2+1
group by Company, Salary


/*另外的做法*/
select Id,Company,Salary from 
(select Id, Company,Salary,
row_number() over (partition by Company order by Salary,id) as row1
 row_number() over (partition by Company order by Salary desc,id desc) as row2 from Employee)tmp
--  之所以在排序的过程中，我们需要对id也进行排序，那是因为我们希望，如果在同一家公司，两个人工资一样的情况，我们会考虑id然后选择抽出谁
 where row1 = row2 or abs(row1 - row2) = 1

