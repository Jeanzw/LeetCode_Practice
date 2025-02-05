select id, name from Students
where department_id not in
(select id from Departments)

-----------------------------------

-- 用join更高效
select
s.id,
s.name
from Students s
left join Departments d on s.department_id = d.id
where d.id is null

-----------------------------------

-- Python
import pandas as pd

def find_students(departments: pd.DataFrame, students: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(students,departments,left_on = 'department_id',right_on = 'id', how = 'left')
    merge = merge[merge['id_y'].isna()]
    return merge[['id_x','name_x']].rename(columns = {'id_x':'id', 'name_x':'name'})