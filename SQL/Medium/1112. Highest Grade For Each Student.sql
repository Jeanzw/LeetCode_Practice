select student_id, course_id, grade from
(select *, rank() over (partition by student_id order by grade desc,course_id) as rnk from Enrollments)tmp
where rnk = 1


-- 如果用mysql来做那么应该是：
with pro_t as (
select student_id, course_id, grade, 
max(grade) over(partition by student_id) as max_grade
from Enrollments)


select student_id, min(course_id) as course_id, grade
from pro_t
where max_grade = grade
group by student_id;


-- 也可以这么做
select student_id,min(course_id) as course_id,grade
from
(select
student_id,
course_id,
grade,
dense_rank() over (partition by student_id order by grade desc) as rnk
from Enrollments)tmp
where rnk = 1
group by 1,3


-- 也可以这么做
with max_grade as
(select 
student_id,max(grade) as max_grade
from Enrollments group by 1)

select 
student_id,min(course_id) as course_id,grade from Enrollments
where (student_id,grade) in
(select * from max_grade)
group by 1,3
order by 1


-- Python
import pandas as pd

def highest_grade(enrollments: pd.DataFrame) -> pd.DataFrame:
    enrollments = enrollments.sort_values(['grade','course_id'],ascending = [0,1])
    enrollments = enrollments.groupby(['student_id'],as_index = False).head(1)
    return enrollments.sort_values('student_id')