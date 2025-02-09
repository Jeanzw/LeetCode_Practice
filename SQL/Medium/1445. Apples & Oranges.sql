select sale_date,
(sum(case when fruit = 'apples' then sold_num else 0 end) 
-
sum(case when fruit = 'oranges' then sold_num else 0 end)) as diff
from Sales
group by 1

-------------------------------

-- 也可以直接用一个case when来处理
select 
sale_date,
sum(case when fruit = 'apples' then sold_num else -sold_num end) as diff
from Sales
group by 1
order by 1

-------------------------------

-- Python
import pandas as pd
import numpy as np

def apples_oranges(sales: pd.DataFrame) -> pd.DataFrame:
    sales['num'] = np.where(sales['fruit'] == 'apples', sales['sold_num'], -sales['sold_num'])
    
    res = sales.groupby('sale_date', as_index = False).num.sum()
    return res.sort_values('sale_date').rename(columns = {'num':'diff'})