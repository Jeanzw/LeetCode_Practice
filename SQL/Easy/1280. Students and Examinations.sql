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

select 
f.student_id,
f.student_name,
f.subject_name,
ifnull(attended_exams,0) as attended_exams
from frame f
left join course e on f.student_id = e.student_id
and f.subject_name = e.subject_name
order by 1,3




-- 再一次做的时候
with frame_work as
(select * from Students,Subjects)

select 
fw.student_id, 
fw.student_name, 
fw.subject_name,
count(e.subject_name) as attended_exams  --这里是很容易出错的点，如果我们用count(*)那么没有参加过任何考试的也会被计作1因为这是按照行数来计数的
-- 而我们这里用count(e.subject_name)，那么如果连不上显示的是null的是不会被计数的
from frame_work fw
left join Examinations e 
on fw.student_id = e.student_id
and fw.subject_name = e.subject_name
group by 1,2,3
order by 1,3



-- Python
import pandas as pd

def students_and_examinations(students: pd.DataFrame, subjects: pd.DataFrame, examinations: pd.DataFrame) -> pd.DataFrame:
    frame = pd.merge(students,subjects, how = 'cross')
    acc = examinations.groupby(['student_id','subject_name'],as_index = False).size()
    
    merge = pd.merge(frame,acc, how = 'left', on = ['student_id','subject_name']).rename(columns = {'size':'attended_exams'})
    merge['attended_exams'] = merge['attended_exams'].fillna(0)
    return merge.sort_values(['student_id','subject_name'])