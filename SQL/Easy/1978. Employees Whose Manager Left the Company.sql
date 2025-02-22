select
distinct e1.employee_id
from Employees e1
left join Employees e2 on e1.manager_id = e2.employee_id
where e2.employee_id is null and e1.salary <30000 and e1.manager_id is not null
order by 1

-----------------------------

-- Python
import pandas as pd

def find_employees(employees: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employees,employees, left_on = 'manager_id', right_on = 'employee_id', how = 'left')
    merge = merge[(merge['salary_x'] < 30000) & (merge['manager_id_x'].notna()) & (merge['employee_id_y'].isna())]
    return merge[['employee_id_x']].rename(columns = {'employee_id_x':'employee_id'}).sort_values('employee_id')