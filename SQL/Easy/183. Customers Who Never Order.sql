select Name as Customers from Customers
where Id not in (select CustomerId from Orders)



-- 也可以用下面的query来写
select
    Name as Customers
    from Customers c
    left join Orders o on c.Id = o.CustomerId
    where o.CustomerId is null




-- python
import pandas as pd

def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    # Select the rows which `id` is not present in orders['customerId'].
    df = customers[~customers['id'].isin(orders['customerId'])]

    # Build a dataframe that only contains the column `name` 
    # and rename the column `name` as `Customers`.
    df = df[['name']].rename(columns={'name': 'Customers'})
    return df