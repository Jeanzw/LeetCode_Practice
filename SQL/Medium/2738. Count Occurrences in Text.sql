select 'bull' as word,
count(distinct case when content like '% bull %' then file_name end) as count
from Files
group by 1

union all 

select 'bear' as word,
count(distinct case when content like '% bear %' then file_name end) as count
from Files
group by 1

-----------------------------

-- Python
import pandas as pd

def count_occurrences(files: pd.DataFrame) -> pd.DataFrame:
    bull = files['content'].str.contains(' bull ').nunique()
    bear = files['content'].str.contains(' bear ').nunique()

    result = pd.DataFrame({'word':['bull','bear'], 'count':[bull,bear]})
    return result