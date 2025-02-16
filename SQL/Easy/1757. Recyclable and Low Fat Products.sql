SELECT product_id from Products
where low_fats = 'Y' and recyclable = 'Y'

------------------------------

-- Python
import pandas as pd

def find_products(products: pd.DataFrame) -> pd.DataFrame:
    products = products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')]
    return products[['product_id']]




-- 或者
import pandas as pd

def find_products(products: pd.DataFrame) -> pd.DataFrame:
    products = products.query("low_fats == 'Y' and recyclable == 'Y'")
    return products[['product_id']].drop_duplicates()