select
distinct a.N,
case when a.P is null then 'Root'
     when b.P is null then 'Leaf'
     else 'Inner' end as Type
from Tree a
left join Tree b on a.N = b.P
order by 1

----------------------------

-- Python
import pandas as pd
import numpy as np
def binary_tree_nodes(tree: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(tree,tree, left_on = 'N', right_on = 'P', how = 'left')
    merge['Type'] = np.where(merge['P_x'].isna(),'Root',
                    np.where(merge['P_y'].isna(),'Leaf','Inner'))
    return merge[['N_x','Type']].rename(columns = {'N_x':'N'}).drop_duplicates().sort_values('N')