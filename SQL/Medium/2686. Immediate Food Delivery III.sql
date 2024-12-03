select
order_date,
round(100* count(distinct case when order_date = customer_pref_delivery_date then delivery_id end)
/
count(distinct delivery_id),2) as immediate_percentage
from Delivery 
group by 1
order by 1


-- Python
import pandas as pd
import numpy as np

def immediate_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    delivery['immediate'] = np.where(delivery['order_date'] == delivery['customer_pref_delivery_date'], delivery['delivery_id'], None)
    -- 返回null值在python里面是None
    delivery = delivery.groupby(['order_date'], as_index = False).agg(
        n = ('immediate','nunique'),
        d = ('delivery_id','nunique')
    )
    delivery['immediate_percentage'] = round(100 * delivery['n']/delivery['d'],2)

    return delivery[['order_date','immediate_percentage']].sort_values('order_date')