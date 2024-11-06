select
customer_id
from Customers
where year = 2021 
group by 1 
having sum(revenue) > 0


-- Python
import pandas as pd

def find_customers(customers: pd.DataFrame) -> pd.DataFrame:
    customers = customers.groupby(['customer_id','year'],as_index = False).revenue.sum()
    customers = customers.query("year == 2021 and revenue > 0")
    return customers[['customer_id']]