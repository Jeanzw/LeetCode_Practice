select student_id, course_id, grade from
(select *, rank() over (partition by student_id order by grade desc,course_id) as rnk from Enrollments)tmp
where rnk = 1