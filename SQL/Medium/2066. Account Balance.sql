select
account_id,
day,
sum(case when type = 'Deposit' then amount else -amount end) over (partition by account_id order by day) as balance
from Transactions
order by 1, 2



-- Python
import pandas as pd
import numpy as np

def account_balance(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['amount'] = np.where(transactions['type'] == 'Deposit',transactions['amount'], -transactions['amount'])
    transactions = transactions.sort_values(['account_id','day'])
    transactions['balance'] = transactions.groupby(['account_id']).amount.cumsum()
    return transactions[['account_id','day','balance']]