select 
    product_id,
    max(case when store = 'store1' then price end) as store1,
    max(case when store = 'store2' then price end) as store2,
    max(case when store = 'store3' then price end) as store3
from Products 
group by 1

-- 或者
select 
    product_id,
    sum(case when store = 'store1' then price end) as store1,
    sum(case when store = 'store2' then price end) as store2,
    sum(case when store = 'store3' then price end) as store3
from Products 
group by 1



-- 另一种做法就是用pivot
SELECT *
FROM (
       SELECT product_id,store,price FROM Products
     )T1
PIVOT
(MAX(price) FOR store IN (
                           [store1],
                           [store2],
                           [store3]
                         ) 
)T2



-- Python
import pandas as pd

def products_price(products: pd.DataFrame) -> pd.DataFrame:
    # Approach: Utilize .pivot() to get unique stores

    # Utilizing product_id as the index, we will destructure the values 
    # as columns and have the values be the price
    df = products.pivot(index='product_id', columns='store', values='price').reset_index()

    return df