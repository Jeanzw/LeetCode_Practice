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

------------------------------

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

------------------------------

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

------------------------------

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

------------------------------

-- 我不是很喜欢用not in来做题
# Write your MySQL query statement below
with cte as
(select
a.student_id,a.student_name, exam_id,
rank() over (partition by exam_id order by score) as rnk,
rank() over (partition by exam_id order by score desc) as rnk_desc
from Student a
inner join Exam b on a.student_id = b.student_id)
,max_min as
(select distinct student_id from cte where rnk = 1 or rnk_desc = 1)

select distinct a.student_id,a.student_name
from cte a
left join max_min b on a.student_id = b.student_id
where b.student_id is null
order by 1

------------------------------

-- 或许我们直接就可以一个cte搞定
with cte as
(select
a.student_id,
a.student_name,
score,
exam_id,
dense_rank() over (partition by exam_id order by score) as rnk,
dense_rank() over (partition by exam_id order by score desc) as rnk_desc
from Student a
inner join Exam b on a.student_id = b.student_id)

select student_id, student_name from cte
group by 1,2
having min(rnk) != 1 and min(rnk_desc) != 1
order by 1

------------------------------

-- Python
import pandas as pd

def find_quiet_students(student: pd.DataFrame, exam: pd.DataFrame) -> pd.DataFrame:
    exam = pd.merge(exam,student, on = 'student_id')
    # 先用transform找到对于每个exam_id的最大最小值
    exam["max_score"] = exam.groupby("exam_id").score.transform(max)
    exam['min_score'] = exam.groupby('exam_id').score.transform(min)
    # 逆向思维，因为我们要找到quiet，那么我们先找到not quiet student
    not_quiet = exam.query('score == max_score or score == min_score')

    # 然后使得student表格里面student_id不在not_quiet里面即可
    res = exam[~exam['student_id'].isin(not_quiet['student_id'])]
    return res[['student_id','student_name']].drop_duplicates().sort_values('student_id')

------------------------------

-- Python另外的做法
import pandas as pd

def find_quiet_students(student: pd.DataFrame, exam: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(student,exam,on = 'student_id')
    merge['rnk'] = merge.groupby(['exam_id']).score.transform('rank',method = 'dense')
    merge['rnk_desc'] = merge.groupby(['exam_id']).score.transform('rank',method = 'dense',ascending = False)
    merge['min_rnk'] = merge.groupby(['student_id']).rnk.transform('min')
    merge['min_rnk_desc'] = merge.groupby(['student_id']).rnk_desc.transform('min')
    return merge.query("min_rnk != 1 and min_rnk_desc != 1")[['student_id','student_name']].drop_duplicates().sort_values('student_id')

-- Python另外的做法
import pandas as pd

def find_quiet_students(student: pd.DataFrame, exam: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(exam,student, on = 'student_id')
    merge['rnk'] = merge.groupby(['exam_id']).score.rank(method = 'dense')
    merge['rnk_desc'] = merge.groupby(['exam_id']).score.rank(method = 'dense',ascending = False)
    not_quiet = merge[(merge['rnk'] == 1) | (merge['rnk_desc'] == 1)]
    
    res = pd.merge(merge,not_quiet,on = 'student_id', how = 'left')
    res = res[res['student_name_y'].isna()]
    return res[['student_id','student_name_x']].rename(columns = {'student_name_x':'student_name'}).drop_duplicates().sort_values('student_id')