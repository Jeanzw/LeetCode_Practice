select Name as Customers from Customers
where Id not in (select CustomerId from Orders)



-- 也可以用下面的query来写
select
    Name as Customers
    from Customers c
    left join Orders o on c.Id = o.CustomerId
    where o.CustomerId is null

-- 或者可以用计数的方式来求
select
a.name as Customers
from Customers a
left join Orders b on a.id = b.customerId
group by a.id, a.name
having count(distinct b.id) = 0


-- python
import pandas as pd

def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(customers,orders, left_on = 'id', right_on = 'customerId', how = 'left')
    return merge.query("customerId.isna()")[['name']].rename(columns = {'name':'Customers'})