select transaction_id from
(select transaction_id,dense_rank() over (partition by date(day) order by amount desc) as rnk
from Transactions)tmp
where rnk = 1
order by 1

------------------------------

-- Python
import pandas as pd

def find_maximum_transaction(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['day'] = transactions['day'].dt.strftime('%Y-%m-%d')
    transactions['daily_max'] = transactions.groupby(['day']).amount.transform(max)
    return transactions.query("amount == daily_max")[['transaction_id']].sort_values('transaction_id')

------------------------------

-- 也可以这样
import pandas as pd

def find_maximum_transaction(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['day'] = transactions['day'].dt.strftime('%Y-%m-%d')
    transactions['rnk'] = transactions.groupby(['day'],as_index = False).amount.rank(method = 'dense', ascending = False)
    return transactions[transactions['rnk'] == 1][['transaction_id']].sort_values('transaction_id')