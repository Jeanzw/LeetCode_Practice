select date_format(order_date,'%Y-%m') as month,
count(distinct order_id) as order_count,
count(distinct customer_id) as customer_count
from Orders
where invoice > 20
group by 1


-- Python
import pandas as pd

def warehouse_manager(warehouse: pd.DataFrame, products: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(warehouse,products, on = 'product_id', how = 'left')
    merge['volume'] = merge['units'] * merge['Width']* merge['Length']* merge['Height']

    res = merge.groupby(['name'], as_index = False).volume.sum().fillna(0)
    return res.rename(columns = {'name':'warehouse_name'})