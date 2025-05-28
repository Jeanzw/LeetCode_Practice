with student_rank as
(select *,
rank() over(partition by department_id order by mark desc) as rnk,
count(student_id) over (partition by department_id) as cnt
from Students
)
select 
student_id,
department_id,
ifnull(round(100 * (rnk - 1) /(cnt - 1),2),0) as percentage
from student_rank

----------------------------------------

-- 不用写cte，直接写
select
student_id,department_id,
ifnull(round(100 * (rank() over (partition by department_id order by mark desc) - 1) 
/
(count(student_id) over (partition by department_id) - 1),2),0) as percentage
from Students

----------------------------------------

-- Python
import pandas as pd
import numpy as np

def compute_rating(students: pd.DataFrame) -> pd.DataFrame:
    students['rnk'] = students.groupby(['department_id']).mark.rank(ascending = False, method = 'min')
    students['cnt'] = students.groupby(['department_id']).student_id.transform('nunique')
    students['percentage'] = np.where(students['cnt'] == 1, 0, 100*(students['rnk'] - 1)/(students['cnt'] - 1))
    students['percentage'] = students['percentage'].round(2)
    return students[['student_id','department_id','percentage']]


----------------------------------------   
-- 这道题本来我想的是这样做：
-- import pandas as pd

-- def compute_rating(students: pd.DataFrame) -> pd.DataFrame:
--     students['percentage'] = 100 * students.groupby(['department_id']).mark.rank(pct = True, ascending = False, method = 'min').round(2)
--     return students[['student_id','department_id','percentage']]

-- 但是这样做是不对的，不对的原因就是我们使用rank返回的是百分位数，但是题目要求的是：percentage = (student_rank - 1) * 100 / (number_of_students_in_department - 1)
-- 这个不是简单的 rank percentile，而是精确的按公式计算