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

--------------------------------

-- Python
import pandas as pd

def rearrange_products_table(products: pd.DataFrame) -> pd.DataFrame: 
    df = products.melt(id_vars='product_id', var_name='store', value_name='price')
    df = df.dropna(axis=0)
    return df

--------------------------------

-- 我觉得上面的做法和sql不太一样，并且不容易记住，所以基于sql的做法，我们仍旧采取分别处理然后用union结合起来
import pandas as pd

def rearrange_products_table(products: pd.DataFrame) -> pd.DataFrame:
    # store 1
    store1 = products[['product_id','store1']].rename(columns = {'store1':'price'})
    store1['store'] = 'store1'
    # store 2
    store2 = products[['product_id','store2']].rename(columns = {'store2':'price'})
    store2['store'] = 'store2'
    # store 3
    store3 = products[['product_id','store3']].rename(columns = {'store3':'price'})
    store3['store'] = 'store3'
    # 将三张表合起来
    res = pd.concat([store1,store2,store3])
    return res.dropna()