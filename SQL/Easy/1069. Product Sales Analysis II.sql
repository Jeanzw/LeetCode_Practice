select 
product_id,
sum(quantity) as total_quantity
from Sales
group by 1


-- Python
import pandas as pd

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    sales = sales.groupby(['product_id'],as_index = False).agg(
        total_quantity = ('quantity','sum') # 用agg我们就不用使用rename啦
    )
    return sales