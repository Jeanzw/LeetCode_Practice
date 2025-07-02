with cte as
(select
case when month(sale_date) in (1,2,12) then 'Winter'
     when month(sale_date) between 3 and 5 then 'Spring'
     when month(sale_date) between 6 and 8 then 'Summer'
     else 'Fall' end as season,
category,
sum(quantity) as total_quantity,
sum(quantity * price) as total_revenue
from sales a
left join products b on a.product_id = b.product_id
group by 1,2)
, rnk as
(select
*, row_number() over (partition by season order by total_quantity desc, total_revenue desc) as rnk
from cte)

select
season,
category,
total_quantity,
total_revenue
from rnk 
where rnk = 1
order by 1

-------------------------

-- Python
import pandas as pd
import numpy as np

def seasonal_sales_analysis(products: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(products,sales, on = 'product_id')
    merge['season'] = np.where((merge['sale_date'].dt.month >= 3) & (merge['sale_date'].dt.month <= 5),'Spring',
                      np.where((merge['sale_date'].dt.month >= 6) & (merge['sale_date'].dt.month <= 8),'Summer',
                      np.where((merge['sale_date'].dt.month >= 9) & (merge['sale_date'].dt.month <= 11),'Fall','Winter')))
    merge['revenue'] = merge['quantity'] * merge['price']
    merge = merge.groupby(['season','category'],as_index = False).agg(
        total_quantity = ('quantity','sum'),
        total_revenue = ('revenue','sum')
    )
    merge.sort_values(['season','total_quantity','total_revenue'], ascending = [1,0,0], inplace = True)
    return merge.groupby(['season']).head(1)