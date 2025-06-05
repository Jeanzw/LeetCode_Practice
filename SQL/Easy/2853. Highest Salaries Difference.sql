select
abs(max(case when department= 'Marketing' then salary end) - max(case when department= 'Engineering' then salary end)) as salary_difference
from Salaries

--------------------

-- Python
import pandas as pd

def salaries_difference(salaries: pd.DataFrame) -> pd.DataFrame:
    mkt = salaries[salaries['department'] == 'Marketing'].salary.max()
    engg = salaries[salaries['department'] == 'Engineering'].salary.max()
    salary_difference = abs(mkt - engg)
    return pd.DataFrame({'salary_difference':[salary_difference]})