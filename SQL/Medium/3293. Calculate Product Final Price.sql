select
a.product_id,
price * (1 - ifnull(discount/100,0)) as final_price,
a.category
from Products a
left join Discounts b on a.category = b.category
order by 1


-- Python
import pandas as pd

def calculate_final_prices(products: pd.DataFrame, discounts: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(products,discounts,on = 'category', how = 'left').fillna(0)
    merge['final_price'] = merge['price'] * (1 - merge['discount']/100)
    return merge[['product_id','final_price','category']].sort_values('product_id')