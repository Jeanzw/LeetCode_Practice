select
a.member_id, a.name,
case when count(distinct b.visit_id) = 0 then 'Bronze'
     when 100 * count(distinct c.visit_id)/count(distinct b.visit_id) >= 80 then 'Diamond'
     when 100 * count(distinct c.visit_id)/count(distinct b.visit_id) >= 50 and 100 * count(distinct c.visit_id)/count(distinct b.visit_id) < 80 then 'Gold'
     else 'Silver' end as category
from Members a
left join Visits b on a.member_id = b.member_id
left join Purchases c on b.visit_id = c.visit_id
group by 1,2

--------------------------------

-- Python
import pandas as pd
import numpy as np

def find_categories(members: pd.DataFrame, visits: pd.DataFrame, purchases: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(members,visits,on = 'member_id', how = 'left').merge(purchases,on = 'visit_id', how = 'left')
    merge = merge.groupby(['member_id','name'],as_index = False).agg(
        n = ('charged_amount','count'),
        d = ('visit_id','nunique')
    )
    merge['category'] = np.where(merge['d'] == 0, 'Bronze',
                        np.where(merge['n']/merge['d'] >= 0.8, 'Diamond',
                        np.where(merge['n']/merge['d'] >= 0.5, 'Gold','Silver')))
    return merge[['member_id','name','category']]