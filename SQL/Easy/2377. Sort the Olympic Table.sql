select
*
from Olympic
order by 2 desc,3 desc,4 desc, 1

-------------------

-- Python
import pandas as pd

def sort_table(olympic: pd.DataFrame) -> pd.DataFrame:
    return olympic.sort_values(['gold_medals','silver_medals','bronze_medals','country'], ascending = [0,0,0,1])