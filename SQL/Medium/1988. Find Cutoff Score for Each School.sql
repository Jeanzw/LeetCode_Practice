select 
    school_id,
    case when score is null then -1 else score end as score
from
(select 
    s.school_id,
    score,
    rank() over (partition by s.school_id order by score asc) as rnk
    from
    Schools s
    left join Exam e on s.capacity >= e.student_count)tmp
    where rnk = 1

--------------------------------------------

-- 另外的做法
select
a.school_id,
min(case when b.score is null then -1 else score end) as score
from Schools a
left join Exam b on a.capacity >= b.student_count
group by 1

--------------------------------------------

-- Python
import pandas as pd

def find_cutoff_score(schools: pd.DataFrame, exam: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(schools,exam,how = 'cross')
    merge = merge.query("capacity >= student_count")
    merge['rnk'] = merge.groupby(['school_id']).score.rank()

    merge = merge.query("rnk == 1")[['school_id','score']]

    res = pd.merge(schools,merge,on = 'school_id',how = 'left').fillna(-1)
    return res[['school_id','score']]

--------------------------------------------

-- 另外的做法
import pandas as pd

def find_cutoff_score(schools: pd.DataFrame, exam: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(schools,exam,how = 'cross')
    merge = merge[merge['capacity'] >= merge['student_count']]
    merge.sort_values(['school_id','score'], ascending = [1,1],inplace = True)
    merge = merge.groupby(['school_id']).head(1)

    res = pd.merge(schools, merge, on = 'school_id', how = 'left').fillna(-1)
    return res[['school_id','score']]

--------------------------------------------

-- 另外的做法
import pandas as pd

def find_cutoff_score(schools: pd.DataFrame, exam: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(exam,schools, how = 'cross')
    merge = merge[merge['capacity'] >= merge['student_count']]
    merge = merge.groupby(['school_id'], as_index = False).score.min()
    
    not_list = schools[~schools['school_id'].isin(merge['school_id'])][['school_id']]
    not_list['score'] = -1

    res = pd.concat([merge,not_list])
    return res