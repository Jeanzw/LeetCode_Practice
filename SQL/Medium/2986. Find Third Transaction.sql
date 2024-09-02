with summary as
(select
*,
lag(spend) over (partition by user_id order by transaction_date) as previous,
lag(spend,2) over (partition by user_id order by transaction_date) as previous_2,
rank() over (partition by user_id order by transaction_date) as rnk
from Transactions)

select user_id,spend as third_transaction_spend, transaction_date as third_transaction_date
from summary
where rnk = 3 and spend > previous and spend > previous_2
order by 1


-- 用rank来做逻辑更清楚
# Write your MySQL query statement below
with cte as
(select *, rank() over (partition by user_id order by transaction_date) as rnk from Transactions)

select
distinct a.user_id, a.spend as third_transaction_spend, a.transaction_date as third_transaction_date
from cte a
inner join cte b on b.rnk = 2 and a.spend > b.spend and a.user_id = b.user_id
inner join cte c on c.rnk = 1 and a.spend > c.spend and a.user_id = c.user_id
where a.rnk = 3
order by 1



-- Python
import pandas as pd

def find_third_transaction(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['rnk'] = transactions.groupby(['user_id']).transaction_date.rank()
    transactions = transactions.sort_values(['user_id','rnk'])
    transactions['p_spend'] = transactions.groupby(['user_id']).spend.shift(1)
    transactions['pp_spend'] = transactions.groupby(['user_id']).spend.shift(2)
    return transactions.query("rnk == 3 and spend > p_spend and spend > pp_spend")[['user_id','spend','transaction_date']].rename(columns = {'spend':'third_transaction_spend','transaction_date':'third_transaction_date'})