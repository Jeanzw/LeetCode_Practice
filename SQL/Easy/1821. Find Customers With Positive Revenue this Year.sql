select
customer_id
from Customers
where year = 2021 
group by 1 
having sum(revenue) > 0

------------------------

-- Python
import pandas as pd

def find_customers(customers: pd.DataFrame) -> pd.DataFrame:
    customers = customers[customers['year'] == 2021]
    customers = customers.groupby(['customer_id'],as_index = False).revenue.sum()
    return customers[customers['revenue'] > 0][['customer_id']]