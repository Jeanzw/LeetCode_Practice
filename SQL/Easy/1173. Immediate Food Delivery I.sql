select 
-- 要非常注意，分子是sum而不是count，不然永远都是6，因为一共有6个delivery_id需要判断
round(sum(order_date = customer_pref_delivery_date) * 100
/
count(delivery_id),2) as immediate_percentage
from Delivery

-----------------------------------------------

select
round( 
100 *
count(distinct case when order_date = customer_pref_delivery_date then delivery_id end)
/
count(distinct delivery_id),2) as immediate_percentage
from Delivery

-----------------------------------------------

-- Python
import pandas as pd

def food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    d = delivery.delivery_id.nunique()
    delivery_imme = delivery.query("order_date == customer_pref_delivery_date")
    n = delivery_imme.delivery_id.nunique()
    return pd.DataFrame({'immediate_percentage':[round(100 * n/d,2)]})

-- 另外的做法
import pandas as pd
import numpy as np

def food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    delivery['delivery'] = np.where(delivery['order_date'] == delivery['customer_pref_delivery_date'], delivery['delivery_id'], None)
    n = delivery.delivery.nunique()
    d = delivery.delivery_id.nunique()
    immediate_percentage = round(100 * n/d,2)
    return pd.DataFrame({'immediate_percentage':[immediate_percentage]})