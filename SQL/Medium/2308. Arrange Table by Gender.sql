with cte as
(select
*,
row_number() over (partition by gender order by user_id) as rnk,
case when gender = 'female' then 1
     when gender = 'other' then 2
     else 3 end as cate_rnk
from Genders)

select user_id, gender 
from cte
order by rnk, cate_rnk


-- Python
import pandas as pd
import numpy as np

def arrange_table(genders: pd.DataFrame) -> pd.DataFrame:
    genders['rnk'] = genders.groupby(['gender']).user_id.rank()
    genders['cate_rnk'] = np.where(genders['gender'] == 'female', 1, np.where(genders['gender'] == 'male',3,2))
    genders = genders.sort_values(['rnk','cate_rnk'])
    return genders[['user_id','gender']]