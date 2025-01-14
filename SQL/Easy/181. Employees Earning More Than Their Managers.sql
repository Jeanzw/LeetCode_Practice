select e1.Name as Employee from Employee e1
left join Employee e2 on e1.ManagerId = e2.Id
where e1.Salary > e2.Salary


-- 其实对于这种题目直接用join结果会更明显
select a.Name as Employee from Employee a
join Employee b on a.ManagerId = b.Id and a.Salary > b.Salary



-- Python
import pandas as pd

def find_employees(employee: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employee,employee,left_on = 'managerId', right_on = 'id')
    merge = merge[merge['salary_x'] > merge['salary_y']]
    return merge[['name_x']].rename(columns = {'name_x':'Employee'})