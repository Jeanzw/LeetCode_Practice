select a.*,ifnull(attended_exams,0) as attended_exams  from 
(select * from Students,Subjects) a
left join
(
select student_id, subject_name, count(*) as attended_exams from Examinations
group by 1,2) b
on a.student_id = b.student_id and a.subject_name = b.subject_name
# group by 1,2,3,4
order by a.student_id, a.subject_name

-- 这一道题我犯了几个错误：
-- 1. 我最开始意味Subjects这张表就是一张废表，然后就被教做人了...
-- 2. 由于Subjects和Subjects两张表其实没有key作为连接，而我又需要将Subjects给加到所有student上面，这种方法我忘记了



-- 第二次做
with frame as
(select student_id,student_name,subject_name from Students,Subjects)
-- 先把框架给搭好，因为可能存在就是0的情况，但是一定是每个同学对应每门课程
,course as
(select student_id, subject_name,count(*) as attended_exams from Examinations
group by 1,2)
-- 把课程数量给统计起来

-- 
select 
f.student_id,
f.student_name,
f.subject_name,
ifnull(attended_exams,0) as attended_exams
from frame f
left join course e on f.student_id = e.student_id
and f.subject_name = e.subject_name
order by 1,3


