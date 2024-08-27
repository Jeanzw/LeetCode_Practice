select
abs(max(case when department= 'Marketing' then salary end) - max(case when department= 'Engineering' then salary end)) as salary_difference
from Salaries


-- Python
import pandas as pd

def salaries_difference(salaries: pd.DataFrame) -> pd.DataFrame:
    # salaries = salaries.groupby(['department'],as_index = False).salary.max()
    en = salaries.query("department == 'Engineering'")['salary'].max()
    ma = salaries.query("department == 'Marketing'")['salary'].max()
    return pd.DataFrame({'salary_difference':[abs(en - ma)]})