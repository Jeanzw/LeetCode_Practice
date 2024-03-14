select 
    school_id,
    case when score is null then -1 else score end as score
from
(select 
    s.school_id,
    score,
    rank() over (partition by s.school_id order by student_count desc, score asc) as rnk
    from
    Schools s
    left join Exam e on s.capacity >= e.student_count)tmp
    where rnk = 1


-- Python
import pandas as pd

def find_cutoff_score(schools: pd.DataFrame, exam: pd.DataFrame) -> pd.DataFrame:
    df = schools.merge(exam, how="cross")

    result = (
        df[df.capacity >= df.student_count]
        .groupby("school_id")["score"]
        .min()
        .reset_index()
        .merge(schools, how="right")
        .fillna(-1)
    )

    return result[["school_id", "score"]]
