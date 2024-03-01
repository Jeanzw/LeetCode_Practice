select customer_id,count(*) as count_no_trans from Visits
where visit_id not in
(select visit_id from Transactions)
group by 1


-- 我们还可以就直接用join来做，这样效率高一点
select
customer_id,
count(distinct v.visit_id) as count_no_trans
from Visits v
left join Transactions t on v.visit_id = t.visit_id
where t.visit_id is null
group by 1


-- Python
import pandas as pd

def find_customers(visits: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:

   visits_no_trans = visits.merge(transactions, on='visit_id', how='left')

   visits_no_trans = visits_no_trans[visits_no_trans.transaction_id.isna()]

   df = visits_no_trans.groupby('customer_id', as_index=False)['visit_id'].count()

   return df.rename(columns={'visit_id': 'count_no_trans'})