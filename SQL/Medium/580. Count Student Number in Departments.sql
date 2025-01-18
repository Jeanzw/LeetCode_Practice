select dept_name,count(student_name) as student_number from department d
left join student s on d.dept_id = s.dept_id
group by 1
order by student_number desc, dept_name


-- Python
import pandas as pd

def count_students(student: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(department,student, on = 'dept_id', how = 'left')
    merge = merge.groupby(['dept_id','dept_name'],as_index = False).student_id.nunique()
    return merge[['dept_name','student_id']].rename(columns = {'student_id':'student_number'}).sort_values(['student_number','dept_name'], ascending = [0,1])