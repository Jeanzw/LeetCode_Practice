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

--------------------------------

-- 另外的做法
select
a.student_id
from students a
left join courses b on a.major = b.major
left join enrollments c on b.course_id = c.course_id and a.student_id = c.student_id and c.grade = 'A'
group by 1
having count(distinct b.course_id) = count(distinct c.course_id)
order by 1

--------------------------------

-- Python
import pandas as pd
import numpy as np

def find_top_scoring_students(enrollments: pd.DataFrame, students: pd.DataFrame, courses: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(students,courses,on = 'major').merge(enrollments,on = ['student_id','course_id'],how = 'left')
    -- merge['A_sum'] = np.where(merge['grade'] == 'A',1,0)
    -- 我觉得用sum来做还是有风险，最保险就是用计数
    merge['A_grade'] = np.where(merge['grade'] == 'A', merge['course_id'],None)
    merge = merge.groupby(['student_id'],as_index = False).agg(
        course_sum = ('course_id','nunique'),
        grade = ('A_sum','sum')
    )
    return merge.query("course_sum == grade")[['student_id']].sort_values('student_id')