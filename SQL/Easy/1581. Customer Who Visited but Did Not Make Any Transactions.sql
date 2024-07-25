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


-- 或者如果不用where visit_id is null，那么就需要在最后保证数是大于0的
select
customer_id,
count(distinct case when transaction_id is null then a.visit_id end) as count_no_trans
from Visits a
left join Transactions b on a.visit_id = b.visit_id
group by 1
having count_no_trans > 0



-- Python
import pandas as pd

def find_customers(visits: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(visits,transactions, on = 'visit_id', how = 'left')
    merge = merge.query("transaction_id.isna()")

    res = merge.groupby(['customer_id'], as_index = False).visit_id.nunique().rename(columns = {'visit_id':'count_no_trans'}).sort_values(['customer_id','count_no_trans'])

    return res