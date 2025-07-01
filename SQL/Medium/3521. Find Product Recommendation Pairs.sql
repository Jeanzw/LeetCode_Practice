with cte as
(select 
a.product_id as product1_id,
b.product_id as product2_id,
a.user_id
from ProductPurchases a
join ProductPurchases b on a.product_id < b.product_id and a.user_id = b.user_id)
, summary as
(select
a.product1_id,
a.product2_id,
count(distinct b.user_id) as customer_count
from cte a
join cte b on a.product1_id = b.product1_id and a.product2_id = b.product2_id
group by 1,2
having customer_count >= 3)

select
a.product1_id,
a.product2_id,
b.category as product1_category,
c.category as product2_category,
a.customer_count
from summary a
left join ProductInfo b on a.product1_id = b.product_id
left join ProductInfo c on a.product2_id = c.product_id
order by 5 desc, 1,2

----------------------
-- Python的做法
import pandas as pd

def find_product_recommendation_pairs(product_purchases: pd.DataFrame, product_info: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(product_purchases,product_purchases, on = 'user_id')
    merge = merge[merge['product_id_x'] < merge['product_id_y']][['product_id_x','product_id_y','user_id']]

    same_bought = pd.merge(merge,merge, on = ['product_id_x','product_id_y'])
    same_bought = same_bought.groupby(['product_id_x','product_id_y'], as_index = False).user_id_y.nunique()
    same_bought = same_bought[same_bought['user_id_y'] >= 3]

    res = pd.merge(same_bought,product_info, left_on = 'product_id_x', right_on = 'product_id')[['product_id_x','product_id_y','category','user_id_y']].merge(product_info, left_on = 'product_id_y', right_on = 'product_id')
    # return res
    return res[['product_id_x','product_id_y','category_x','category_y','user_id_y']].rename(columns = {'product_id_x':'product1_id','product_id_y':'product2_id','category_x':'product1_category','category_y':'product2_category','user_id_y':'customer_count'}).sort_values(['customer_count','product1_id','product2_id'], ascending = [0,1,1])