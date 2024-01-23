with salary_rank as
(select 
d.Name as Department,
e.Name as Employee,
Salary,
dense_rank() over (partition by DepartmentId order by Salary desc) as rnk
from Employee e
join Department d
on e.DepartmentId = d.Id)

select Department, Employee, Salary from salary_rank
where rnk <= 3


-- Python
import pandas as pd
​
def top_three_salaries(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    
    Employee_Department = employee.merge(department, left_on='departmentId', right_on='id').rename(columns = {'name_y': 'Department'})

    Employee_Department = Employee_Department[['Department', 'departmentId', 'salary']].drop_duplicates()
    
    top_salary = Employee_Department.groupby(['Department', 'departmentId']).salary.nlargest(3).reset_index()
    
    df = top_salary.merge(employee, on=['departmentId', 'salary'])
    
    return df[['Department', 'name', 'salary']].rename(columns = {'name': 'Employee', 'salary': 'Salary'})