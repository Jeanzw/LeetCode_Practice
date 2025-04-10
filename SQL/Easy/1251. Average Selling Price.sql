select p.product_id,
round(sum(price * units)/sum(units),2) as average_price
from Prices p
left join UnitsSold u
on p.product_id = u.product_id 
and u.purchase_date between p.start_date and p.end_date
group by 1

--------------------------------------------

-- 上面的用法通过不了了，因为新的版本我们是想要完全保留Prices就算里面没有卖出去任何一件物品，那么返回0
select
a.product_id,
ifnull(round(sum(price * units)/sum(units),2),0) as average_price
from Prices a
left join UnitsSold b on a.product_id = b.product_id and purchase_date between start_date and end_date
group by 1

--------------------------------------------

-- Python
import pandas as pd
import numpy as np

def average_selling_price(prices: pd.DataFrame, units_sold: pd.DataFrame) -> pd.DataFrame:
    # 先连接
    merge = pd.merge(prices,units_sold, on = 'product_id', how = 'left')
    # 只选取满足条件的行
    merge = merge[((merge['purchase_date'] >= merge['start_date']) & (merge['purchase_date'] <= merge['end_date'])) | (merge['purchase_date'].isna())].fillna(0)
    # 进行计算
    merge['sum_price'] = merge['price'] * merge['units']
    res = merge.groupby(['product_id'], as_index = False).agg(
        sum_price = ('sum_price','sum'),
        sum_unit = ('units','sum')
    )
    # 最后用一个where来对null值进行处理
    res['average_price'] = np.where(res['sum_price']/res['sum_unit'].notna(),res['sum_price']/res['sum_unit'],0)
    return res[['product_id','average_price']].round(2)