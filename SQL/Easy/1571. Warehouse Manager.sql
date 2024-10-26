select 
name as warehouse_name,
-- 我们要考虑某个warehouse没有任何一件物品的情况
ifnull(sum(Width * Length * Height * units),0) as volume
-- 在这里可以直接进行处理，而不需要用到cte
from Warehouse w
left join Products p on w.product_id = p.product_id
group by 1


-- Python
import pandas as pd

def warehouse_manager(warehouse: pd.DataFrame, products: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(warehouse,products,on = 'product_id',how = 'left')
    merge['volume'] = merge['units'] * merge['Width'] * merge['Length'] * merge['Height']
    merge = merge.groupby(['name'],as_index = False).volume.sum().fillna(0)
    return merge.rename(columns = {'name':'warehouse_name'})