-- 另外的做法，就是我们已经把参加考试的同学进行了一次筛选并且匹配上了排名
-- 然后用not in在已经筛选过了的表中进行筛选
with rank_student as
(select
a.student_id,
a.student_name,
dense_rank() over (partition by exam_id order by score) as rnk,
dense_rank() over (partition by exam_id order by score desc) as rnk_desc
from Student a
inner join Exam b on a.student_id = b.student_id)

select distinct student_id,student_name from rank_student
where student_id not in 
(select distinct student_id from rank_student
where rnk = 1 or rnk_desc = 1)
order by 1






with non_quiet as
(select distinct student_id from
(select 
    *,
    dense_rank() over (partition by exam_id order by score) as rnk_acs,
    dense_rank() over (partition by exam_id order by score desc) as rnk_desc
    from Exam) tmp
    where rnk_acs = 1 or rnk_desc = 1)
    
    select b.student_id,b.student_name from Exam a
    left join Student b on a.student_id = b.student_id
    where a.student_id not in (select * from non_quiet)
    group by b.student_id,b.student_name
    order by student_id


-- 其实可以不用任何的left join，直接用in和not in处理这一道题
with not_quiet_student as
(select student_id  from 
(select 
*,
dense_rank() over (partition by exam_id order by score desc) as rnk_desc,
dense_rank() over (partition by exam_id order by score) as rnk
from Exam)tmp
where rnk_desc = 1 or rnk = 1)

select student_id,student_name from Student
where student_id not in (select student_id from not_quiet_student)
and student_id in (select student_id from Exam)



-- 我们也可以在not in里面讨论rnk的问题
with not_quiet as
(select
student_id,
dense_rank() over (partition by exam_id order by score) as rnk,
dense_rank() over (partition by exam_id order by score desc) as rnk_desc
from Exam)

select
*
from Student
where student_id not in (select student_id from not_quiet where rnk = 1 or rnk_desc = 1)
and student_id in (select student_id from Exam)