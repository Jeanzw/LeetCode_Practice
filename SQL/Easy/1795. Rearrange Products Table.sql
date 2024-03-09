SELECT 
    product_id,
    'store1' as store,
    store1 as price 
    from Products
    where store1 is not null

union all

SELECT 
    product_id,
    'store2' as store,
    store2 as price 
    from Products
    where store2 is not null

union all

SELECT 
    product_id,
    'store3' as store,
    store3 as price 
    from Products
    where store3 is not null


-- Python
import pandas as pd

def rearrange_products_table(products: pd.DataFrame) -> pd.DataFrame: 
    df = products.melt(id_vars='product_id', var_name='store', value_name='price')
    df = df.dropna(axis=0)
    return df