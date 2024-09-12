with cte as
(select
a.student_id,
count(distinct b.course_id) as total_courses,
count(distinct case when grade = 'A' then c.course_id end) as taken_A_courses
from students a
inner join courses b on a.major = b.major
left join enrollments c on b.course_id = c.course_id and a.student_id = c.student_id
group by 1)

select student_id from cte 
where total_courses = taken_A_courses
order by 1


-- Python
import pandas as pd
import numpy as np

def find_top_scoring_students(enrollments: pd.DataFrame, students: pd.DataFrame, courses: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(students,courses,on = 'major').merge(enrollments,on = ['student_id','course_id'],how = 'left')
    merge['A_sum'] = np.where(merge['grade'] == 'A',1,0)
    merge = merge.groupby(['student_id'],as_index = False).agg(
        course_sum = ('course_id','nunique'),
        grade = ('A_sum','sum')
    )
    return merge.query("course_sum == grade")[['student_id']].sort_values('student_id')