select month,country,
sum(case when type = 'approved' then 1 else 0 end) as approved_count,
sum(case when type = 'approved' then amount else 0 end) as approved_amount,
sum(case when type = 'chargeback' then 1 else 0 end) as chargeback_count,
sum(case when type = 'chargeback' then amount else 0 end) as chargeback_amount 
from 
(
(select date_format(trans_date,'%Y-%m') as month, country,amount,'approved' as type from Transactions where state = 'approved')

union all

(select date_format(c.trans_date,'%Y-%m') as month, country,amount,'chargeback' as type from Transactions t join CHargebacks c on id = trans_id)
)tmp
group by month, country