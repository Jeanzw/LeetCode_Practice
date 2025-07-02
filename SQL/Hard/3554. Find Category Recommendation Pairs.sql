with cte as
(select
b.category,
a.user_id
from ProductPurchases a
left join ProductInfo b on a.product_id = b.product_id
group by 1,2)
, bundle as 
(select
a.category as category1,
b.category as category2,
a.user_id
from cte a
join cte b on a.user_id = b.user_id and a.category < b.category)

select
a.category1,
a.category2,
count(distinct b.user_id) as customer_count
from bundle a
join bundle b on a.category1 = b.category1 and a.category2 = b.category2
group by 1,2
having customer_count >= 3
order by 3 desc, 1, 2

---------------------

-- Python
import pandas as pd

def find_category_recommendation_pairs(product_purchases: pd.DataFrame, product_info: pd.DataFrame) -> pd.DataFrame:
    summary = pd.merge(product_purchases,product_info, on = 'product_id')[['category','user_id']].drop_duplicates()

    bundle = pd.merge(summary,summary,on = 'user_id')
    bundle = bundle[bundle['category_x'] < bundle['category_y']]
    
    res = pd.merge(bundle,bundle, on = ['category_x','category_y'])
    res = res.groupby(['category_x','category_y'],as_index = False).user_id_y.nunique()
    res = res[res['user_id_y'] >= 3]
    return res.rename(columns = {'category_x':'category1','category_y':'category2','user_id_y':'customer_count'}).sort_values(['customer_count','category1','category2'], ascending = [0,1,1])