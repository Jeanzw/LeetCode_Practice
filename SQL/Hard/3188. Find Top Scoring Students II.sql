with cte as
(select
a.student_id, a.name, a.major,
-- mandatory
count(distinct case when mandatory = 'yes' then b.course_id end) as mandatory_list,
count(distinct case when mandatory = 'yes' and b.course_id = c.course_id then b.course_id end) as mandatory_taken,
count(distinct case when mandatory = 'yes' and b.course_id = c.course_id and c.grade = 'A' then b.course_id end) as mandatory_A_taken,
-- elective
count(distinct case when mandatory = 'no' then b.course_id end) as elective_list,
count(distinct case when mandatory = 'no' and b.course_id = c.course_id then b.course_id end) as elective_taken,
count(distinct case when mandatory = 'no' and b.course_id = c.course_id and c.grade in ('A','B') then b.course_id end) as elective_A_B_taken,
-- avg gpa
avg(c.GPA) as avg_gpa
from students a
inner join courses b on a.major = b.major
left join enrollments c on a.student_id = c.student_id
group by 1,2,3
having mandatory_list = mandatory_A_taken and elective_taken = elective_A_B_taken and elective_taken >= 2 and avg_gpa >= 2.5)

select distinct student_id from cte
order by 1




-- Python
import pandas as pd
import numpy as np

def find_top_scoring_students(students: pd.DataFrame, courses: pd.DataFrame, enrollments: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(students,courses, on = 'major').merge(enrollments,on = 'student_id', how = 'left')
    avg_gpa = enrollments.groupby(['student_id'],as_index = False).GPA.mean()

    mandatory_list = merge.query("mandatory == 'Yes'").groupby(['student_id'],as_index = False).course_id_x.nunique()
    mandatory = merge.query("mandatory == 'Yes' and course_id_x == course_id_y")
    mandatory = mandatory.groupby(['student_id','grade'], as_index = False).agg(
        man_list = ('course_id_x','nunique'),
        man_taken = ('course_id_y','nunique')
    )
    mandatory = pd.merge(mandatory_list,mandatory, on = 'student_id')
    mandatory = mandatory.query("grade != 'A' or course_id_x != man_taken")

    elective = merge.query("mandatory == 'No' and course_id_x == course_id_y")    
    elective['grade'] = np.where(elective['grade'].isin(['A','B']), 1, 0)
    elective = elective.groupby(['student_id','grade'], as_index = False).agg(
        ele_taken = ('course_id_y','nunique'),
    )
    elective['grade_cate'] = elective.groupby('student_id').grade.transform('count')
    elective = elective.query("grade == 1 and ele_taken >= 2 and grade_cate == 1")

    summary = pd.merge(avg_gpa,mandatory,on = 'student_id', how = 'left').merge(elective, on = 'student_id', how = 'left')
    # return summary
    return summary.query("grade_x.isna() and ~grade_y.isna() and GPA >= 2.5")[['student_id']].sort_values(['student_id'])