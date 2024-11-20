select
teacher_id, count(distinct subject_id) as cnt
from Teacher
group by 1


-- Python
import pandas as pd

def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:
    teacher = teacher.groupby(['teacher_id'],as_index = False).subject_id.nunique()
    return teacher.rename(columns = {'subject_id':'cnt'})