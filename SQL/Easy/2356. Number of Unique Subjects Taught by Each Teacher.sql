select
teacher_id, count(distinct subject_id) as cnt
from Teacher
group by 1


-- Python
import pandas as pd

def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:
    df = teacher.groupby(["teacher_id"])["subject_id"].nunique().reset_index()
    df = df.rename({'subject_id': "cnt"}, axis=1)
    return df