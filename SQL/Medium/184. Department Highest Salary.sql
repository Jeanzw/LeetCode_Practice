-- 方法1：先求出每个departmentid对应的最大工资数
-- 然后确保我们抽出来的人的工资和部门与之对应即可
select Department.Name as Department, Employee.Name as Employee, Salary
from Employee
join Department on Employee.DepartmentId = Department.Id
where (Employee.DepartmentId, Salary) in
(select DepartmentId, max(Salary) from Employee group by DepartmentId)

-- 直接用rank求解
/* Write your T-SQL query statement below */
select 
    Department,
    Employee,
    Salary
    from
(select 
    d.Name as Department,
    e.Name as Employee, 
    Salary,
    dense_rank() over (partition by d.Name order by Salary desc) as rnk
from Employee e
join Department d   
-- 这里我们用join不用left join是因为可能department根本就没有，那么在这种情况我们输出的是空值
on e.DepartmentId = d.Id)a
where rnk = 1

-- 注意这里的join是内链接而不是left join，因为我们不能保证Employee这一张表中所有的人都只是在这两个部门里面
-- 题目给了这么一个例子：也就是说我的department里面是什么都没有的
-- {"headers": {"Employee": ["Id", "Name", "Salary", "DepartmentId"], "Department": ["Id", "Name"]}, 
--     "rows": {"Employee": [[1, "Joe", 10000, 1]],                   "Department": []}}
-- 那么我们如果用的是left JOIN那么其实还是会返回：
-- {"headers": ["Department", "Employee", "Salary"], "values": [[null, "Joe", 10000]]}
-- 这个并不是我们想要的，我们希望得到的是：
-- {"headers": ["Department", "Employee", "Salary"], "values": []}
-- 所以只能用inner join





-- Python
import pandas as pd

def department_highest_salary(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employee,department,left_on = 'departmentId',right_on = 'id')
    merge['rnk'] = merge.groupby(['departmentId']).salary.rank(method = 'dense', ascending = False)
    return merge.query("rnk == 1")[['name_y','name_x','salary']].rename(columns = {'name_y':'Department','name_x':'Employee'})