-- mysql
select seller_id from Sales 
group by 1
having sum(price) =
(select sum(price) from Sales
group by seller_id
order by sum(price) desc limit 1)

------------------------------

-- MS sql
select seller_id from
(select seller_id, rank() over(order by sum(price) desc) as rank
from sales group by seller_id) b
where rank = 1

------------------------------

-- Python
import pandas as pd

def sales_analysis(product: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    sales = sales.groupby(['seller_id'],as_index = False).price.sum()
    sales['rnk'] = sales.price.rank(method = 'dense', ascending = False)
    sales = sales[sales['rnk'] == 1]
    return sales[['seller_id']]