/*我的做法就是直接用in然后最后把head给排除掉*/
select employee_id from Employees 
where manager_id in
(select employee_id from Employees
where manager_id in
(select employee_id from Employees 
where manager_id = 1))

and employee_id != 1



/*我另外看到一人写的MS SQl Server，虽说思路是和我的一样，不过他的做法有点意思
此人做法就是相当于是人为分层，这样比较清楚明了
我把第一层的设为1，第二层的设为2，第三层的设为3
*/
Select a.employee_id
From (
Select Distinct employee_id, 1 As Ranks
From Employees
Where manager_id = 1 And employee_id != 1
Union All
Select Distinct employee_id, 2 As Ranks
From Employees
Where manager_id In (
Select Distinct employee_id
From Employees
Where manager_id = 1 And employee_id != 1
)
Union All
Select Distinct employee_id, 3 As Ranks
From Employees
Where manager_id In (
Select Distinct employee_id
From Employees
Where manager_id In (
Select Distinct employee_id
From Employees
Where manager_id = 1 And employee_id != 1
)
)
) a
Order By a.Ranks, a.employee_id


/*
最后这道题其实最原始的思路就是用一个self join
*/
select
  r3.employee_id
from
  employees r1
  join employees r2
    on r2.manager_id = r1.employee_id
  join employees r3
    on r3.manager_id = r2.employee_id
where
  r1.manager_id = 1 and r3.employee_id != 1
;



-- 我再一次做的时候，则直接用left join去做
select a.employee_id from Employees a
left join Employees b on a.manager_id = b.employee_id
left join Employees c on b.manager_id = c.employee_id
where c.manager_id = 1 and a.employee_id != 1