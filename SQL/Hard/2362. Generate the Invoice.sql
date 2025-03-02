with cte as
(select
invoice_id,
sum(quantity * price) as tt
from Purchases a
left join Products b on a.product_id = b.product_id
group by 1
order by 2 desc, 1
limit 1)

select 
a.product_id,a.quantity,price * quantity as price
from Purchases a
inner join cte b on a.invoice_id = b.invoice_id
left join Products c on a.product_id = c.product_id

------------------------------

-- Python
import pandas as pd

def generate_the_invoice(products: pd.DataFrame, purchases: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(purchases,products,on = 'product_id')
    merge['price'] = merge['price'] * merge['quantity']
    merge['total_price'] = merge.groupby(['invoice_id']).price.transform('sum')
    
    top_1 = merge.sort_values(['total_price','invoice_id'], ascending = [0,1]).head(1)[['invoice_id']]

    res = pd.merge(merge, top_1, on = 'invoice_id')
    return res[['product_id','quantity','price']]