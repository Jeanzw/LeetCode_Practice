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



-- Python
import pandas as pd

def generate_the_invoice(products: pd.DataFrame, purchases: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(products,purchases,on = 'product_id')
    merge['sum_price'] = merge['price'] * merge['quantity']
    invoice = merge.groupby(['invoice_id'],as_index = False).sum_price.sum().sort_values(['sum_price','invoice_id'], ascending = [0,1]).head(1)

    summary = pd.merge(invoice,merge, on ='invoice_id')
    return summary[['product_id','quantity','sum_price_y']].rename(columns = {'sum_price_y':'price'})