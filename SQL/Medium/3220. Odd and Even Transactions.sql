select
transaction_date,
ifnull(sum(case when mod(amount,2) = 1 then amount end),0) as odd_sum,
ifnull(sum(case when mod(amount,2) = 0 then amount end),0) as even_sum
from transactions 
group by 1
order by 1

----------------------------------

-- Python
import pandas as pd
import numpy as np
def sum_daily_odd_even(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['even'] = np.where(transactions['amount'].mod(2) == 0, transactions['amount'],0)
    transactions['odd'] = np.where(transactions['amount'].mod(2) == 1, transactions['amount'],0)
    transactions = transactions.groupby(['transaction_date'],as_index = False).agg(
        odd_sum = ('odd','sum'),
        even_sum = ('even','sum')
    )
    return transactions.sort_values('transaction_date')