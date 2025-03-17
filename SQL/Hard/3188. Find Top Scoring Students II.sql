with cte as
(select
a.student_id, a.name, a.major,
-- 我们在算课程数量的时候一定要注意，因为我们课程数量是按照courseid来进行的，但是gpa是按照所有的课程，很可能有同学上了某个course_id但是这个课程id并不在courses里面
-- 基于上面的case，我们在判断b.course_id = c.course_id 的时候不能像3182. Find Top Scoring Students一样将这个判断放在on里面，而应该作为case when里面的判断标准
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

-----------------------------------

-- 或者这样做
with cte as
(select
a.student_id,
count(distinct case when b.mandatory = 'yes' then b.course_id end) as mandatory_course,
count(distinct case when b.mandatory = 'yes' then c.course_id end) as mandatory_course_taken,
count(distinct case when b.mandatory = 'yes' and c.grade = 'A' then c.course_id end) as mandatory_course_taken_A,

count(distinct case when b.mandatory = 'no' then b.course_id end) as elective_course,
count(distinct case when b.mandatory = 'no' then c.course_id end) as elective_course_taken,
count(distinct case when b.mandatory = 'no' and c.grade in ('A','B') then c.course_id end) as elective_course_taken_A_B
from students a
left join courses b on a.major = b.major
left join enrollments c on b.course_id = c.course_id and a.student_id = c.student_id
group by 1)
, gpa as
(select student_id, avg(GPA) as gpa from enrollments group by 1)

select a.student_id from cte a
left join gpa b on a.student_id = b.student_id
where mandatory_course = mandatory_course_taken_A and elective_course_taken >= 2 and elective_course_taken = elective_course_taken_A_B and gpa >= 2.5
order by 1

-----------------------------------

-- Python
import pandas as pd
import numpy as np

def find_top_scoring_students(students: pd.DataFrame, courses: pd.DataFrame, enrollments: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(students,courses,on = 'major').merge(enrollments, on = 'student_id', how = 'left')
# 先求出平均绩点，将不满足2.5绩点的给筛掉
    avg_gpa = merge.groupby(['student_id'],as_index = False).GPA.mean()
    avg_gpa = avg_gpa[avg_gpa['GPA'] > 2.5]
# 把mandatory的总数量算出来
    mandatory_list = merge[merge['mandatory'] == 'Yes'].groupby(['student_id'],as_index = False).course_id_x.nunique()
# 把每个同学上的mandatory并且得到A的课程算出来
    mandatory = merge[(merge['mandatory'] == 'Yes') & (merge['course_id_x'] == merge['course_id_y']) & (merge['grade'] == 'A')]
    mandatory = mandatory.groupby(['student_id'],as_index = False).course_id_x.nunique()
# 与上面求出的mandatory的总数进行merge，如果数量匹配，那么保留，不然就筛掉
    mandatory_filter = pd.merge(mandatory_list,mandatory,on = 'student_id')
    mandatory_candidate = mandatory_filter[mandatory_filter['course_id_x_x'] == mandatory_filter['course_id_x_y']]

# 将选修课给抽出来
    elective = merge[(merge['mandatory'] == 'No') & (merge['course_id_x'] == merge['course_id_y'])]
# 用where来判断是否满足选修课成绩至少是B的条件
    elective['A_B_elective'] = np.where(elective['grade'].isin(['A','B']), elective['course_id_y'], None)
# 计算上的选修课和满足条件的选修课
    elective = elective.groupby(['student_id'],as_index = False).agg(
        elective_taken = ('course_id_x','nunique'),
        elective = ('A_B_elective','nunique')
    )
    elective_candidate = elective[(elective['elective_taken'] == elective['elective']) & (elective['elective'] >= 2)]

# 最后将三张表进行merge，找到最后的结果
    res = pd.merge(avg_gpa,mandatory_candidate, on = 'student_id').merge(elective_candidate, on = 'student_id')
    return res[['student_id']].sort_values('student_id')

-----------------------------------

-- 另外的做法
import pandas as pd
import numpy as np

def find_top_scoring_students(students: pd.DataFrame, courses: pd.DataFrame, enrollments: pd.DataFrame) -> pd.DataFrame:
    # 合并三个数据框
    merge = pd.merge(students, courses, on='major', how='left').merge(enrollments, on=['student_id', 'course_id'], how='left')
    
    # 处理缺失值，确保grade列比较时不会出现NaN导致的错误
    # 必修课程且成绩为A的条件
    merge['mandatory_course_taken_A'] = np.where(
        (merge['mandatory'] == 'Yes') & 
        merge['grade'].notna() &  # 新增对grade非空的检查
        (merge['grade'] == 'A'), 
        merge['course_id'], 
        None
    )
    
    # 其他字段处理，同样处理grade的缺失值
    merge['mandatory_course'] = np.where(merge['mandatory'] == 'Yes', merge['course_id'], None)
    merge['elective_course'] = np.where(merge['mandatory'] == 'No', merge['course_id'], None)
    merge['elective_course_taken'] = np.where(
        (merge['mandatory'] == 'No') & 
        merge['grade'].notna(),  # 已存在的非空检查
        merge['course_id'], 
        None
    )
    merge['elective_course_taken_A_B'] = np.where(
        (merge['mandatory'] == 'No') & 
        merge['grade'].notna() &  # 新增非空检查
        merge['grade'].isin(['A', 'B']), 
        merge['course_id'], 
        None
    )
    
    # 按学生聚合统计
    grouped = merge.groupby('student_id').agg(
        mandatory_course=('mandatory_course', 'nunique'),
        mandatory_course_taken_A=('mandatory_course_taken_A', 'nunique'),
        elective_course_taken=('elective_course_taken', 'nunique'),
        elective_course_taken_A_B=('elective_course_taken_A_B', 'nunique')
    ).reset_index()
    
    # 筛选符合条件的记录
    filtered = grouped[
        (grouped['mandatory_course'] == grouped['mandatory_course_taken_A']) &
        (grouped['elective_course_taken'] >= 2) &
        (grouped['elective_course_taken'] == grouped['elective_course_taken_A_B'])
    ]
    
    # 计算平均GPA并筛选
    avg_gpa = enrollments.groupby('student_id')['GPA'].mean().reset_index()
    avg_gpa = avg_gpa[avg_gpa['GPA'] >= 2.5]
    
    # 合并结果
    result = pd.merge(filtered, avg_gpa, on='student_id')
    return result[['student_id']]