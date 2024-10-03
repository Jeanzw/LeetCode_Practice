select product_name, year,price from Sales s left join Product p
on s.product_id = p.product_id


select product_name,year,price from Product p
join Sales s on p.product_id = s.product_id


-- 我们其实可以看到上面join的先后顺序是不一样的，前者因为是先Sales后product所以直接用left join就可以
-- 但是后者如果我们用了left join就会导致Samsung的信息也会被包含进去
-- 所以我们改用join



-- Python
import pandas as pd

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(sales,product,on = 'product_id')
    return merge[['product_name','year','price']]