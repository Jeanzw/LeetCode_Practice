/*我的做法就是直接用in然后最后把head给排除掉*/
select employee_id from Employees 
where manager_id in
(select employee_id from Employees
where manager_id in
(select employee_id from Employees 
where manager_id = 1))

and employee_id != 1

-----------------------------------------------

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

----------------------------

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

-----------------------------------

-- 其实对于上面这种做法，我们还可以逆向来，但是原理是一样的
-- 也就是说，我们从下级往上推，只要保证最后能够推到Boss那里即可
select distinct a.employee_id from Employees a
join Employees b on b.employee_id = a.manager_id
join Employees c on c.employee_id = b.manager_id
join Employees d on d.employee_id = c.manager_id
where d.employee_id = 1 and a.employee_id != 1

-------------------------

-- 我再一次做的时候，则直接用left join去做
select a.employee_id from Employees a
left join Employees b on a.manager_id = b.employee_id
left join Employees c on b.manager_id = c.employee_id
where c.manager_id = 1 and a.employee_id != 1

---------------------------

-- 用python
import pandas as pd

def find_reporting_people(employees: pd.DataFrame) -> pd.DataFrame:
    employee = employees.query('employee_id != 1')
    employee1 = employee.query('manager_id == 1')[['employee_id']]
    employee2 = employee[employee['manager_id'].isin(employee1['employee_id'])]
    employee3 = employee[employee['manager_id'].isin(employee2['employee_id'])]
    
    res = pd.concat([employee1[['employee_id']],employee2[['employee_id']],employee3[['employee_id']]])
    return res.drop_duplicates()

--------------------------------------------

-- 用python按照我们写sql的思路走
import pandas as pd

def find_reporting_people(employees: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employees,employees,left_on = 'manager_id',right_on = 'employee_id').merge(employees,left_on = 'manager_id_y',right_on = 'employee_id')
    merge = merge[(merge['employee_id_x'] != 1) & (merge['manager_id'] == 1)]
    return merge[['employee_id_x']].rename(columns = {'employee_id_x':'employee_id'}).drop_duplicates()