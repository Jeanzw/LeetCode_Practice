with summary as
(select 
    customer_id, 
    transaction_date, 
    transaction_id, 
    row_number() over (partition by customer_id order by transaction_date desc) as rnk
from Transactions)
, bridge as
(select *, dateadd(day, rnk,transaction_date) as bridge from summary)
, cal as
(select 
    customer_id, 
    bridge, 
    count(distinct transaction_id) as total_trans,
    dense_rank() over (order by count(distinct transaction_id) desc) as rnk
from bridge
group by customer_id, bridge)

select customer_id from cal where rnk = 1 order by 1



-- Python
import pandas as pd

def find_customers(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['rnk'] = transactions.groupby(['customer_id']).transaction_date.rank()
    transactions['bridge'] = transactions['transaction_date'] - pd.to_timedelta(transactions['rnk'],unit = 'D')
    transactions = transactions.groupby(['customer_id','bridge'],as_index = False).transaction_id.nunique()
    transactions['rnk'] = transactions.transaction_id.rank(method = 'dense', ascending = False)
    return transactions[transactions['rnk'] == 1][['customer_id']].sort_values('customer_id')