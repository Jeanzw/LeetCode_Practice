select
a.salesperson_id,
a.name,
ifnull(sum(price),0) as total
from Salesperson a
left join Customer b on a.salesperson_id = b.salesperson_id
left join Sales c on b.customer_id = c.customer_id
group by 1,2


-- Python
import pandas as pd

def calculate_influence(salesperson: pd.DataFrame, customer: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    customer_sales = pd.merge(customer,sales,on ='customer_id').groupby(['salesperson_id'],as_index = False).price.sum()

    summary = pd.merge(salesperson,customer_sales,on = 'salesperson_id', how = 'left').fillna(0)
    return summary.rename(columns = {'price':'total'})