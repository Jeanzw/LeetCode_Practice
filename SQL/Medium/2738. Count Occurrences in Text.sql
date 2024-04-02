select 'bull' as word,
count(distinct case when content like '% bull %' then file_name end) as count
from Files
group by 1

union all 

select 'bear' as word,
count(distinct case when content like '% bear %' then file_name end) as count
from Files
group by 1


-- Python
import pandas as pd

def count_occurrences(files: pd.DataFrame) -> pd.DataFrame:
    bull_count = files["content"].str.contains(" bull ", case=False).sum()
    bear_count = files["content"].str.contains(" bear ", case=False).sum()

    data = {"word": ["bull", "bear"], "count": [bull_count, bear_count]}

    result_df = pd.DataFrame(data)

    return result_df
