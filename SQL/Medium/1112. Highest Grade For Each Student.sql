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